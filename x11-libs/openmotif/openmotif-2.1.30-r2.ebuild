# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header:

MY_P=${P}-4_MLI.src
S=${WORKDIR}/motif
DESCRIPTION="Open Motif (Metrolink Bug Fix Release)"
SRC_URI="ftp://ftp.metrolink.com/pub/openmotif/2.1.30-4/${MY_P}.tar.gz"
HOMEPAGE="http://www.metrolink.com/openmotif/"
LICENSE="MOTIF"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"

DEPEND="virtual/glibc
	virtual/x11"

SLOT="0"

#
# glibc-2.3.2-r1/gcc-3.2.3 /w `-mcpu=athlon-xp -O2', right-clicking
# in nedit triggers DPMS monitor standby instead of popping up the 
# context menu.  this doesn't happen on my `stable' test partition 
# where everything is compiled i686, nor with most non-essential 
# packages athlon-xp and only motif i686.  needs investigation.
#
inherit flag-o-matic
replace-flags "-mcpu=athlon-xp" "-mcpu=i686"

src_unpack() {

	local cfg="${S}/config/cf/site.def"

	unpack ${A}
	cd ${S}

	cp ${FILESDIR}/site.def ${S}/config/cf/
	echo >>$cfg
	echo >>$cfg "#undef  OptimizedCDebugFlags"
	echo >>$cfg "#define OptimizedCDebugFlags ${CFLAGS}"
	echo >>$cfg "#undef  OptimizedCplusplusDebugFlags"
	echo >>$cfg "#define OptimizedCplusplusDebugFlags ${CXXFLAGS}"

	# move `system.mwmrc' from `lib/X11' to `lib/X11/mwm' (but install into
	# `/etc/X11/mwm')
	ebegin "patching 'clients/mwm/Imakefile' (mwm confdir)"
	LC_ALL="C" sed -i \
	  -e 's:\(SpecialObjectRule.*WmResParse\.o.*/lib/X11\)\(.*\):\1/mwm\2:'\
	  -e 's:\(InstallNonExecFile.system\.mwmrc,\).*/lib/X11\(.*\):\1/etc/X11/mwm\2:'\
	    "${S}/clients/mwm/Imakefile"
	eend $? || die

	#
	epatch ${FILESDIR}/${P}-imake-tmpdir.patch
}

src_compile() {

	mkdir -p imports/x11
	cd imports/x11
	ln -s /usr/X11R6/bin bin
	ln -s /usr/X11R6/include include
	ln -s /usr/X11R6/lib lib
	cd ${S}
	make World || die
}

src_install() {

	# these overlap with X11
	local NOINSTBIN="imake lndir makedepend makeg mergelib mkdirhier xmkmf"
	local NOINSTMAN1="imake lndir makedepend makeg mkdirhier xmkmf"

	make DESTDIR=${D} VARDIR=${D}/var/X11/ install || die "make install"
	make DESTDIR=${D} install.man || die "make install.man"

	ln -s "../../../../etc/X11/mwm" \
	      "${D}usr/X11R6/lib/X11/mwm" || die "ln -s confdir"

	mv "${D}usr/X11R6/lib/X11/app-defaults"\
	   "${D}etc/X11" || die "mv app-defaults"

	rm -rf "${D}usr/X11R6/lib/X11/config" || die "rm config"

	for nib in $NOINSTBIN; do
		f="${D}usr/X11R6/bin/${nib}"; rm "$f" || die "rm $f"
	done
	for nim in $NOINSTMAN1; do
		f="${D}usr/X11R6/man/man1/${nim}.1x"; rm "$f" || die "rm $f"
	done

	prepman "/usr/X11R6"

	dodoc README COPYRIGHT.MOTIF RELEASE RELNOTES
	dodoc BUGREPORT OPENBUGS CLOSEDBUGS

}
