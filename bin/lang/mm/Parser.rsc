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
* @file         lang::mm::Parser.rsc
* @brief        Parse an input diagram given as a string
* @contributor  Ferdy van den Hoed - f.k.vdhoed@gmail.com - HvA, CREATE-IT
* @date         July 5th 2017
* @note         Language: Rascal
*/
/*****************************************************************************/

module lang::mm::Parser

import lang::mm::AST;

import String;
import List;

public Diagram parseDiagram(str src) {
	if(!startsWith(src, "diagram({") && findFirst(src, "})") != -1)
		return diagram({});
	set[Element] es = {};
	src = "," + substring(src,9,size(src)-2);
	
	while(src != "" && charAt(src, 0) == 44) {
		int endE =  findFirst(src, "))") + 1; //NOTE: that this pattern only occurs at element for now
		str element = substring(src, 1, endE+1);
		if(startsWith(element, "e_node"))
			es += parseNode(element);
		else if(startsWith(element, "e_edge"))
			es += parseEdge(element);
		src = replaceFirst(src, ","+element, ""); // end condition
	}
	
	return diagram(es);
}

private Element parseNode(str src) {
	if(!startsWith(src, "e_node") || !endsWith(src, "))"))
		return null;
	src = substring(src, 7, size(src)-1);
	
	list[str] args = split(",", src);
	if(size(args) != 6)
		return null;
	
	NodeType t = parseNodeType(top(args));
	args = delete(args, 0);
	
	When w = parseWhen(top(args));
	args = delete(args, 0);
	
	Act a = parseAct(top(args));
	args = delete(args, 0);
	
	How h = parseHow(top(args));
	args = delete(args, 0);
	
	ID i = parseID(top(args));
	args = delete(args, 0);
	
	Category c = parseCategory(top(args));
	
	return e_node(t, w, a, h, i, c);
}

private NodeType parseNodeType(str src){
	switch(src){
		case "t_pool()":
			return t_pool();
		case "t_gate()":
			return t_gate();
		case "t_source()":
			return t_source();
		case "t_drain()":
			return t_drain();
		case "t_converter()":
			return t_converter();
		default:
			throw "NodeType <src> could not be parsed.";
	};
}

private When parseWhen(str src) {
	switch(src){
		case "when_passive()":
			return when_passive();
		case "when_user()":
			return when_user();
		case "t_source()":
			return when_auto();
		case "when_auto()":
			return when_auto();
		case "when_start()":
			return when_start();
		default:
			throw "When <src> could not be parsed.";
	};
}

private Act parseAct(str src) {
	switch(src){
		case "act_pull()":
			return act_pull();
		case "act_push()":
			return act_push();
		default:
			throw "Act <src> could not be parsed.";
	};
}

private How parseHow(str src) {
	switch(src){
		case "how_any()":
			return how_any();
		case "how_all()":
			return how_all();
		default:
			throw "How <src> could not be parsed.";
	};
}

private ID parseID(str src) {
	if(startsWith(src, "id(\"") && endsWith(src, "\")"))
		return id(substring(src, 4, size(src) - 2));
	throw "ID <src> could not be parsed.";
}

private Category parseCategory(str src) {
	if(startsWith(src, "cat(\"") && endsWith(src, "\")"))
		return cat(substring(src, 5, size(src) - 2));
	if(src == "cat_var()")
		return cat_var();
	throw "Category <src> could not be parsed.";
}

private Element parseEdge(str src){
	if(!startsWith(src, "e_edge") || !endsWith(src, "))"))
		throw "Edge <src> could not be parsed.";
	src = substring(src, 7, size(src)-1);
	
	list[str] args = split(",", src);
	int size = size(args);
	if(!(size == 5 || size == 6))
		throw "Edge <src> could not be parsed.";
		
	if(size == 6)
		args = perExp(args); //TODO: figure out how to direct acces list

	EdgeType et = parseEdgeType(top(args));
	args = delete(args, 0);
	
	ID n = parseID(top(args));
	args = delete(args, 0);
	
	ID s = parseID(top(args));
	args = delete(args, 0);
	
	Exp e = parseExp(top(args));
	args = delete(args, 0);
	
	ID t = parseID(top(args));
	
	return e_edge(et,n,s,e,t);
}

list[str] perExp(list[str] args) {
	str t = last(args);
	args = delete(args, 5);
	str e = ","+last(args);
	args = delete(args, 4);
	e = last(args) + e;
	args = delete(args, 3);
	
	args = insertAt(args, 3, e);
	args = insertAt(args, 4, t);
	
	return args;
}

private EdgeType parseEdgeType(str src){
	switch(src){
		case "t_flow()":
			return t_flow();
		case "t_state()":
			return t_state();
		case "t_trigger()":
			return t_trigger();
		case "t_condition()":
			return t_condition();
		default:
			throw "EdgeType <src> could not be parsed.";
	};
}

private Exp parseExp(str src) {
	switch(src){
		case "e_one()":
			return e_one();
		case "e_trigger()":
			return e_trigger();
	};
	if(startsWith(src, "e_die(") && endsWith(src, ")"))
		return e_die(toInt(substring(src, 6, size(src)-1)));
	if(startsWith(src, "e_per(") && endsWith(src, ")")){
		list[str] args = split(",", substring(src, 6, size(src)-1));
		if(size(args) != 2)
			return null;
		Exp e = parseExp(top(args));
		args = delete(args, 0);
		return e_per(e, toInt(top(args)));
	}
	throw "Exp <src> could not be parsed.";
}