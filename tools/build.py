#! /usr/bin/env python3
#
# pylint: disable=C
#
import argparse
import os
import pathlib
import re
import shutil
import subprocess
import sys
import zipfile

import pbo

def ok():
    print("ok")

def abort(text):
    print("ERROR: " + text)
    sys.exit(1)

def main():
    argParser = argparse.ArgumentParser()
    argParser.add_argument("dest", help="mission destination directory")
    argParser.add_argument("-p", "--pbo", action="store_true", help="build pbo files for each terrain")
    argParser.add_argument("-z", "--zip", action="store_true", help="build pbo files and compress them into zipfile")

    args = argParser.parse_args()

    missionName = "=BTC=co@30_Hearts_and_Minds"
    terrain = "Altis" # Default terrain
    mod = "" # Default mod
    rootSourcePath        = (pathlib.Path("..")) / (missionName + "." + terrain)
    missionSourceList     = rootSourcePath.glob('**/*.sqm')
    destPathBase          = pathlib.Path(args.dest)

    for missionSourcePath in missionSourceList:

        # Mod and terrain detection
        # Treat tpo files differently to account for faction and
        # maps with _ in the name
        if 'tpo' == missionSourcePath.parent.name:
            sqmName = missionSourcePath.name.split("_")
            mod = sqmName[1] # Faction
            terrain = '_'.join(sqmName[2:]).split(".")[0]
        else:
            sqmName = missionSourcePath.name.split("_")
            if len(sqmName) != 1:
                m, mod, terrainSqf = sqmName
                terrain, sqf = terrainSqf.split(".")

        print("{:15}".format(terrain), end="")

        # Name file genration
        if mod == "":
            missionNameFinal = missionName + "." + terrain
        else:
            print("{:15}".format(mod), end="")
            missionNameFinal = missionName + "_" + mod + "." + terrain
        missionDestPath = destPathBase / missionNameFinal

        # Copy files
        try:
            if os.path.exists(missionDestPath):
                shutil.rmtree(missionDestPath)

            shutil.copytree(rootSourcePath, missionDestPath, ignore=shutil.ignore_patterns('*.sqm', 'tpo'))
            shutil.copyfile(missionSourcePath, missionDestPath / "mission.sqm")

        except IOError as e:
            abort(str(e))

        # tpo mission modifications
        # Some missions may have player faction on a side that isn't west
        # Faction can be west, east, guerrila, civilian
        factions = {'Police': 'guerrila'}
        for faction in list(factions.keys()):
            if faction in mod:
                # Update side
                with open(os.path.join(missionDestPath, 'core', 'def', 'mission.sqf'), "r+") as f:
                    content = f.read()
                    f.seek(0)
                    f.write(re.sub(r"(\s+missionNamespace.*)(west)(.*)",
                                   r"\1"+f"{factions[faction]}"+r"\3",
                                   content,
                                   re.M))
                    f.truncate()
                # Update equipment
                shutil.copyfile(missionSourcePath.parent.absolute() / (faction+".sqf"), missionDestPath / "define_mod.sqf")


        # pbo file generation
        if args.zip or args.pbo:
            try:
                destStr = str(missionDestPath)
                with pbo.PboWriter(destStr) as pboWriter:
                    pboWriter.writeDir(destStr)
            except IOError as e:
                abort("pbo packing:" + str(e))

        # zip file generation
        if args.zip:
            print("{:15}".format("zip"), end="")
            zipPath = destPathBase / (missionNameFinal + ".zip")
            with zipfile.ZipFile(str(zipPath), "w", compression=zipfile.ZIP_DEFLATED) as pboZip:
                pboFile = missionNameFinal + ".pbo"
                pboPath = destPathBase / pboFile
                pboZip.write(str(pboPath), arcname=pboFile)
        ok()

if __name__ == "__main__":
    main()
