# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/gcc-3.2.2.ebuild,v 1.27 2005/05/28 07:10:50 vapier Exp $

# This version is really meant JUST for the ps2

MAN_VER=""
PATCH_VER="1.0"
UCLIBC_VER=""
PIE_VER=""
PP_VER=""
HTB_VER=""

ETYPE="gcc-compiler"

SPLIT_SPECS=${SPLIT_SPECS-true}

inherit toolchain eutils

DESCRIPTION="The GNU Compiler Collection.  Includes C/C++ and java compilers"

KEYWORDS="-*"
