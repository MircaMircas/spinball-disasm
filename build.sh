#!/usr/bin/env bash
BIN_FOLDER_NAME="bin"
OUTPUT_FOLDER_NAME="output"
ERRORS_OUTPUT_FILENAME="spinball.log"
ERRORS_OUTPUT_FILE="${OUTPUT_FOLDER_NAME}/${ERRORS_OUTPUT_FILENAME}"

main() {
  init_env

  if try_run_assembler asm68k; then
    finalise_build
  elif try_run_assembler axm68k; then
    finalise_build
  else
    echo Could not find supported assembler. Currently expects asm68k.exe or axm68k.exe
  fi
}

init_env() {
  if [[ ! -d ${OUTPUT_FOLDER_NAME} ]]; then
    mkdir ${OUTPUT_FOLDER_NAME}
  fi

  if [[ ! -d ${BIN_FOLDER_NAME} ]]; then
    mkdir ${BIN_FOLDER_NAME}
  fi

  if [[ -e "./${BIN_FOLDER_NAME}/spinbuilt.bin" ]]; then
    mv "./${BIN_FOLDER_NAME}/spinbuilt.bin" "./${BIN_FOLDER_NAME}/spinbuilt.prev.bin"
  fi
}

try_run_assembler() {
  if [[ -e "./$1.exe" ]]; then
    echo "------------------------------------------------------------------------"
    echo "Building Sonic Spinball..."
    echo "------------------------------------------------------------------------"
    wine $1 /k /p /o ae-,v+,c+ "spinball.asm", "${BIN_FOLDER_NAME}\\spinbuilt.bin" >"${ERRORS_OUTPUT_FILE}" , "${OUTPUT_FOLDER_NAME}\\spinbuilt.sym", "${OUTPUT_FOLDER_NAME}\\spinbuilt.lst"
    return 0
  fi

  return -1
}

finalise_build() {
  echo "------------------------------------------------------------------------"
  echo "Errors"
  echo "------------------------------------------------------------------------"
  if [[ ! -e ${ERRORS_OUTPUT_FILE} ]]; then
    touch ${ERRORS_OUTPUT_FILE}
  fi
  cat ${ERRORS_OUTPUT_FILE}

  echo "------------------------------------------------------------------------"
  echo "Build completed!"
  echo "------------------------------------------------------------------------"
}

main
