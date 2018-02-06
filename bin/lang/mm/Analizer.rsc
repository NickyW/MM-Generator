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
* @file         lang::mm::Analizer.rsc
* @brief        Analize if a diagram has certain properties
* @contributor  Ferdy van den Hoed - f.k.vdhoed@gmail.com - HvA, CREATE-IT
* @date         July 5th 2017
* @note         Language: Rascal
*/
/*****************************************************************************/

module lang::mm::Analizer

import lang::mm::AST;

import Set;

public bool isConnected(Diagram d)
  = isConnected(d.elements);

// es = elements?
// e_node = edge node?
public bool isConnected(set[Element] es)
{
  visit(es)
  {
    case e_node(_,_,_,_,id,_):
    {
      if(size({ e | e: e_edge(_,_,id,_,_) <- es}) != 1 || size({ e | e: e_edge(_,_,_,_,id) <- es}) != 1)
        return false;
    }
  }
  return true;
}