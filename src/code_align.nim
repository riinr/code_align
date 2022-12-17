# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

import std/[enumerate,tables,sequtils,strutils,hashes]


type
  Ctxs    = Hash
  LineObj = object
    pos : Natural
    inde: Natural
    ctxs: Ctxs
    cols: seq[string]
  Line    = ref LineObj


proc newLine(pos, inde: Natural; ctxs: Ctxs; cols: seq[string]): Line =
  Line(pos: pos, inde: inde, ctxs: ctxs, cols: cols)


proc hash(line: Line): Hash =
  line.ctxs


proc `$`(line: Line): string =
  align($line.pos, 3) & ":" & $line.ctxs


when isMainModule:
  # text from stdin
  # test to   stdout
  # char sep  first  argument  (default is '=')
  # char rest indent switchers (default is [' ', ".", ":"])
  #
  # indent switchers any char that its repetition before first sep changes context
  # examples:
  # python blocks space indentation ' '
  # java properties '.'
  # nix modules values '.' and ' '
  
  var ctx     = @[' ', '.', ':']
  var sep     = '='
  var sepOut  = " = "
  var space   = ' '
  var all     = initTable[Hash, seq[Line]]()
  var colMax  = initTable[Hash, seq[Natural]]()
  var outList = newSeq[Line]()


  for line in stdin.readAll.splitLines:
    var cols = line.split(sep)
    let inde = Natural(cols[0].find(AllChars - {space}) + 1)
    let ctxs = ctx.foldl(a & ":" & $cols[0].strip(chars={space}).split(b).len, $inde).hash
    cols = cols.mapIt(it.strip(chars={space}))
    let info = newLine(Natural(outList.len), inde, ctxs, cols)

    if not all.hasKey ctxs:
      all[ctxs] = newSeq[Line]()

    all[ctxs].add info

    if not colMax.hasKey ctxs:
      colMax[ctxs] = newSeq[Natural]()

    for i, col in enumerate(cols):
      if i > colMax[ctxs].len - 1:
        colMax[ctxs].add Natural(cols[i].len)
      else:
        colMax[ctxs][i] = max(colMax[ctxs][i], Natural(cols[i].len))

    outList.add info


  let lastLineIdx = outList.len - 1
  for lineNum, line in enumerate(outList):
    let lastColIdx = line.cols.len - 1
    if line.inde > 1:
        stdout.write space.repeat(line.inde - 1)
    for colNum, col in enumerate(line.cols):
      if colNum == lastColIdx:
        stdout.write col
      else:
        stdout.write alignLeft(col, colMax[line.ctxs][colNum]) & sepOut
    if lineNum != lastLineIdx:
      stdout.write '\n'

