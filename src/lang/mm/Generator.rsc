
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
* @file         lang::mm::Generator.rsc
* @brief        Generates a Random Micro-Machinations Diagram
* @contributor  Stefan Leijnen - s.leijnen@hva.nl - HvA, CREATE-IT / CWI
* @date         May 22th 2017
* @note         Language: Rascal
*/
/*****************************************************************************/

module lang::mm::Generator

import lang::mm::AST;

import Set;
import util::Math;

// nCnt = node count?
// eCnt = edge/element count?
// es = ?
public Diagram randomDiagram(int nCnt, int eCnt) {
	set[Element] es = randomNodes(nCnt);
	es += randomEdges(eCnt, nCnt);
	return diagram(es);
}

// nCnt = node count?
// s in nts/ws/as/hs = ?
private set[Element] randomNodes(int nCnt) {
	// e_node(NodeType nodeType, When when, Act act, How how, ID name, Category cat)
	set[NodeType] nts = {t_pool(), t_gate(), t_source(), t_drain(), t_converter()};
	set[When] ws = {when_passive(), when_user(), when_auto(), when_start()};
	set[Act] as = {act_pull(), act_push()};
	set[How] hs = {how_any(), how_all()};
	
	set[Element] es = {};
	for(int n <- [0 .. nCnt]) {
		es += e_node(
			getOneFrom(nts),
			getOneFrom(ws), 
			getOneFrom(as), 
			getOneFrom(hs), 
			id("n" + toString(n)), 
			cat_var()
		);
	}
	return es;
}

// eCnt = edge/element count?
// nCnt = node count?
// s in ets/es = ?
private set[Element] randomEdges(int eCnt, int nCnt) {
	//e_edge(EdgeType edgeType, ID name, ID src, Exp exp, ID tgt)
	set[EdgeType] ets = {t_flow(), t_state(), t_trigger(), t_condition()};
	
	set[Element] es = {};
	for(int n <- [0 .. eCnt]) {
		es += e_edge(
			getOneFrom(ets),
			id("e" + toString(n)),
			id("n" + toString(arbInt(nCnt))),
			randomExp(false),
			id("n" + toString(arbInt(nCnt)))
		);
	}
	return es;
}

// e in e_one/e_trigger/e_die/e_per = ?
private Exp randomExp(bool isRecursive) {
	// desugared e_one() e_trigger() e_die(int size) e_per(Exp e, int n)
	int r = arbInt(isRecursive ? 3 : 4);
	switch (r) {
		case 0:
			return e_one();
		case 1:
			return e_trigger();
		case 2:
			return e_die(arbInt(10)+1);
		case 3:
			return e_per(randomExp(true), arbInt(10)+1);
	}
}