# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/gnat.eclass,v 1.6 2004/06/25 00:39:48 vapier Exp $
#
# Author: David Holm <dholm@telia.com>
#
# This eclass contains some common settings for gnat based ada stuff
# It also strips some flags to bring C[XX]FLAGS in cpmpliance with gcc-2.8.1

ECLASS=gnat

inherit flag-o-matic

INHERITED="$INHERITED $ECLASS"

DEPEND="dev-lang/gnat"

DESCRIPTION="Based on the ${ECLASS} eclass"

#
# Settings for gnat-3.15p:
#

ADAC=${ADAC:-gnatgcc}
ADAMAKE=${ADAMAKE:-gnatmake}
ADABIND=${ADABIND:-gnatbind}

filter-mfpmath "sse 387"

filter-flags "-mmmx -msse -mfpmath -frename-registers \
	-fprefetch-loop-arrays -falign-functions=4 -falign-jumps=4 -falign-loops=4 \
	-msse2 -frerun-loop-opt -maltivec -mabi=altivec -pipe"

ADACFLAGS=${ADACFLAGS:-${CFLAGS}}
ADACFLAGS=${ADACFLAGS//pentium-mmx/i586}
ADACFLAGS=${ADACFLAGS//pentium[234]/i686}
ADACFLAGS=${ADACFLAGS//k6-[23]/k6}
ADACFLAGS=${ADACFLAGS//athlon-tbird/i686}
ADACFLAGS=${ADACFLAGS//athlon-4/i686}
ADACFLAGS=${ADACFLAGS//athlon-[xm]p/i686}
ADACFLAGS=${ADACFLAGS//athlon/i686}
ADACFLAGS=${ADACFLAGS//-Os/-O2}

ADAMAKEFLAGS=${ADAMAKEFLAGS:-"-cargs ${ADACFLAGS} -margs"}
ADABINDFLAGS=${ADABINDFLAGS:-""}

export ADAC ADACFLAGS ADAMAKE ADAMAKEFLAGS ADABIND ADABINDFLAGS
