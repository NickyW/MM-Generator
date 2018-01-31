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

// dCnt = diagram count?
// nM = node something?
// nR = node something?
// eM = edge/element something?
// eR = edge/element something?
// c = ?
// nc = ?
// n = ?
public void generate(int dCnt, int nM, nR, eM, eR) {
	println("start");
	loc file = |project://MM-Generator/output/connected.txt|;
	writeFile(file, "");
	int c = 0;
	int nc = 0;
	for(int n <- [0 .. dCnt]) {
		int nCnt = arbInt(nR) + nM; // r4 m1(1-4) & r5 m3(3-7)
		int eCnt = arbInt(eR) + eM; // r4 m1(1-4) & r4 m3(3-6)
		Diagram d = randomDiagram(nCnt, nCnt);
		if(isConnected(d)) {
			appendToFile(file, d);
			c+=1;
			}
		else nc+=1;
	}
	
	println(toString(nc) + " " + toString(c));
}

// dCnt = diagram count?
// cCnt = something count?
// vCnt = something count?
// dl = delete?
public void checkInput(str file) {
	if(!endsWith(file, ".txt"))
		file += ".txt";
	str src = readFile(|project://MM-Generator/input/| + file);
	list[str] dl = split("\n", src);
	int dCnt =  size(dl);
	int cCnt = 0;
	int vCnt = 0;
	while(size(dl) != 0) {
		str s = top(dl);
		dl = delete(dl, 0);
		try
			lang::mm::AST::MM var = mm_implode(parse(#start[MM], s));
		catch e:
			continue;
		//parseDiagram(s);
		vCnt+=1;
		if(isConnected(d))
			cCnt+=1;
	}
	println("Total entries:"+toString(dCnt));
	println("Total valit diagrams:"+toString(vCnt));
	println("Total connected diagrams:"+toString(cCnt));
}
