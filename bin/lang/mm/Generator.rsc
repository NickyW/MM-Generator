
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

// Generates a random diagram
//
// @param	nodeCnt	The amount of nodes to generate.
// @param	edgeCnt	The amount of edges to generate.
// @return			The random generated diagram.
public Diagram randomDiagram(int nodeCnt, int edgeCnt) {
	set[Element] elements = randomNodes(nodeCnt);
	elements += randomEdges(edgeCnt, nodeCnt);
	return diagram(elements);
}

// Generates a set of nodes with random a type, when, act and how.
//
// @param	nodeCnt	The amount of nodes to generate.
// @return			The generated set of nodes.
private set[Element] randomNodes(int nodeCnt) {
	// e_node(NodeType nodeType, When when, Act act, How how, ID name, Category cat)
	set[NodeType] nodeTypes = {t_pool(), t_gate(), t_source(), t_drain(), t_converter()};
	set[When] nodeWhens = {when_passive(), when_user(), when_auto(), when_start()};
	set[Act] nodesActs = {act_pull(), act_push()};
	set[How] nodeHows = {how_any(), how_all()};
	
	set[Element] elements = {};
	for(int n <- [0 .. nodeCnt]) {
		elements += e_node(
			getOneFrom(nodeTypes),
			getOneFrom(nodeWhens), 
			getOneFrom(nodesActs), 
			getOneFrom(nodeHows), 
			id("n" + toString(n)), 
			cat_var()
		);
	}
	return elements;
}

// Generates a set of edges with random sources and targets.
// Note:	Edges reference to nodes by their id.
//			This method assumes that nodes have a n+integer and that all numbers between 0 and nodeCnt are valid ids.
//
// @param	edgeCnt		The amount of edges to generate.
// @param	nodeLimit	The first integer value of the node id that is invalid. 
// @return				The generated set of edges.
private set[Element] randomEdges(int edgeCnt, int nodeLimit) {
	//e_edge(EdgeType edgeType, ID name, ID src, Exp exp, ID tgt)
	set[EdgeType] edgeTypes = {t_flow(), t_state(), t_trigger(), t_condition()};
	
	set[Element] elements = {};
	for(int n <- [0 .. edgeCnt]) {
		elements += e_edge(
			getOneFrom(edgeTypes),
			id("e" + toString(n)),
			id("n" + toString(arbInt(nodeLimit))),
			randomExp(false),
			id("n" + toString(arbInt(nodeLimit)))
		);
	}
	return elements;
}

// Generates a desugred expression for an edge.
//
// @param	isRecursive	Determines if the method has called itself. (The per expression takes another expression as parameter.)
// @return				The generated expression.		
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