# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/debug.eclass,v 1.16 2002/06/24 05:37:57 spider Exp $

# Author: Spider
# A general DEBUG eclass to ease inclusion of debugging information and to remove "bad" flags from CFLAGS

# Debug ECLASS
ECLASS="debug"

# Do _NOT_ strip symbols in the build! Need both lines for Portage 1.8.9+
DEBUG="yes"
RESTRICT="nostrip"
# Remove omit-frame-pointer as some useless folks define that all over the place. they should be shot with a 16 gauge slingshot at least :)
# force debug information
export CFLAGS="${CFLAGS/-fomit-frame-pointer/} -g"
export CXXFLAGS="${CXXFLAGS/-fomit-frame-pointer/} -g"
# einfo "CFLAGS and CXXFLAGS redefined"

