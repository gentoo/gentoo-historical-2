# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Tod Neidt <tneidt@fidnet.com>
# /home/cvsroot/gentoo-x86/skel.build,v 1.7 2001/08/25 21:15:08 chadh Exp

S=${WORKDIR}/${P}

DESCRIPTION="Python Imaging Library (PIL)."

SRC_URI="http://www.pythonware.com/downloads/${P}.tar.gz"

HOMEPAGE="http://www.pythonware.com/downloads/#pil"

DEPEND=">=dev-lang/python-2.0
	>=media-libs/jpeg-6a
	>=sys-libs/zlib-0.95
	tcltk? ( dev-lang/tcl-tk )"
	
#Change tcltk dependency to: tcltk? ( dev-tcltk/tk ),
#if my separated tcl and tk ebuilds ever make it in portage tree.

RDEPEND="${DEPEND}"

src_compile() {
 
	#This is a goofy build.
 
	#Build the core imaging library (libImaging.a)
	cd ${S}/libImaging
	
	./configure --prefix=/usr \
		--host=${CHOST} || die
	cp Makefile Makefile.orig

	#Not configured by configure
	sed \
    	-e "s:\(JPEGINCLUDE=[[:blank:]]*/usr/\)local/\(include\).*:\1\2:" \
		-e "s:\(OPT=[[:blank:]]*\).*:\1${CFLAGS}:" \
	Makefile.orig > Makefile
	
	emake || die
	
	#Build loadable python modules	
	cd ${S}
	
	local scmd=""

	#First change all the "/usr/local" to "/usr" 
	scmd="$scmd s:/usr/local:/usr:g;"
		
	# adjust for USE tcltk
	if use tcltk; then
		# Find the version of tcl/tk that has headers installed.
		# This will be the most recently merged, not necessarily the highest
		# version number.
		tclv=$(grep TCL_VER /usr/include/tcl.h | sed 's/^.*"\(.*\)".*/\1/')
		tkv=$( grep  TK_VER /usr/include/tk.h  | sed 's/^.*"\(.*\)".*/\1/')
		# adjust Setup to match
		scmd="$scmd s/-ltcl[0-9.]* -ltk[0-9.]*/-ltcl$tclv -ltk$tkv/;" 
	else
		scmd="$scmd s:\(^_imagingtk\):#\1:;"
	fi
	
	sed "$scmd" Setup.in > Setup

	#No configure (#$%@!%%)
	scmd=""
	cp Makefile.pre.in Makefile.pre.in.orig
	#change all the "/usr/local" to "/usr" (haven't we been here before)
	scmd="$scmd s:/usr/local:/usr:g;"
	#fix man paths
	scmd="$scmd "'s:^\(MANDIR=.*/\)\(man\):\1share/\2:;'
	#Insert make.conf CFLAGS settings
	scmd="$scmd "'s:$(OPT)'":${CFLAGS}:;"

	sed "$scmd" Makefile.pre.in.orig > Makefile.pre.in
	
	#Now generate a top level Makefile
	make -f Makefile.pre.in boot || die

	emake || die

}

src_install () {

	#grab python verision so ebuild doesn't depend on it
	local pv
	pv=$(python -V 2>&1 | sed -e 's:Python \([0-9].[0-9]\).*:\1:')
	
	
	insinto /usr/lib/python$pv/site-packages
	doins PIL.pth
	
	insinto /usr/lib/python$pv/site-packages/PIL
	doins _imaging.so PIL/*
	use tcltk && doins _imagingtk.so
	
	dodoc CHANGES CONTENTS FORMATS README

}

