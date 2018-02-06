@license{
  Copyright (c) 2009-2015 CWI / HvA
  All rights reserved. This program and the accompanying materials
  are made available under the terms of the Eclipse Public License v1.0
  which accompanies this distribution, and is available at
  http://www.eclipse.org/legal/epl-v10.html
}
/*****************************************************************************/
/*!
* Micro-Machinations Generator
* @package      lang::mm
* @file         lang::mm::Main.rsc
* @brief        main
* @contributor  Ferdy van den Hoed - f.k.vdhoed@gmail.com - HvA, CREATE-IT
* @date         July 5th 2017
* @note         Language: Rascal
*/
/*****************************************************************************/

module lang::mm::Main

import lang::mm::AST;
import lang::mm::Generator;
import lang::mm::Analizer;
import lang::mm::Parser;
import lang::mm::Syntax;

import List;
import IO;
import List;
import util::Math;
import String;
import ParseTree;

// Generates MM diagrams and displays the number of connected diagrams. (Where every node is at least connected to one other node.)
//
// @param diagramCnt	The number of diagrams to generate.
// @param nodeOffset	The minimum amount of nodes to generate.
// @param nodeLimit		The limit of random nodes to generate.
// @param edgeOffset	The minimum amount of edges to generate.
// @param edgeLimit		The limit of random edges to generate.
public void generate(int diagramCnt, int nodeOffset, nodeLimit, edgeOffset, edgeLimit) {
	println("start");
	loc file = |project://MM-Generator/output/connected.txt|;
	writeFile(file, "");
	int connectedDiagramCnt = 0;
	int nonConnectedDiagramCnt = 0;
	for(int n <- [0 .. diagramCnt]) {
		int nodeCnt = arbInt(nodeLimit) + nodeOffset; // r4 m1(1-4) & r5 m3(3-7)
		int edgeCnt = arbInt(edgeLimit) + edgeOffset; // r4 m1(1-4) & r4 m3(3-6)
		Diagram d = randomDiagram(nodeCnt, edgeCnt);
		if(isConnected(d)) {
			appendToFile(file, d);
			connectedDiagramCnt+=1;
			}
		else nonConnectedDiagramCnt+=1;
	}
	
	println(toString(nonConnectedDiagramCnt) + " " + toString(c));
}

// Reads the file from the input folder, checks if the diagrams are valid and if they are connected. (Where every node is at least connected to one other node.)
public void checkInput(str file) {
	if(!endsWith(file, ".txt"))
		file += ".txt";
	str src = readFile(|project://MM-Generator/input/| + file);
	list[str] diagrams = split("\n", src);
	int diagramCnt =  size(diagrams);
	int connectedDiagramCnt = 0;
	int validDiagramCnt = 0;
	while(size(diagrams) != 0) {
		str diagram = top(diagrams);
		diagrams = delete(diagrams, 0);
		try
			lang::mm::AST::MM var = mm_implode(parse(#start[MM], diagram));
		catch e:
			continue;
		//parseDiagram(diagram);
		validDiagramCnt+=1;
		if(isConnected(d))
			connectedDiagramCnt+=1;
	}
	println("Total entries:"+toString(diagramCnt));
	println("Total valid diagrams:"+toString(validDiagramCnt));
	println("Total connected diagrams:"+toString(connectedDiagramCnt));
}
