# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/psemu-peopsspu/psemu-peopsspu-1.0.7.ebuild,v 1.1 2003/07/13 08:51:59 vapier Exp $

inherit eutils

DESCRIPTION="P.E.Op.S Sound Emulation (SPU) PSEmu Plugin"
HOMEPAGE="http://peops.sourceforge.net/"
SRC_URI="mirror://sourceforge/peops/PeopsSpu${PV//./}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"
IUSE="alsa oss"

DEPEND="alsa? ( media-libs/alsa-lib )
	app-arch/unzip
	=x11-libs/gtk+-1*
	sys-devel/automake"

S=${WORKDIR}

src_unpack() {
	unpack ${A}

	cd src/linuxcfg
	tar -zxf spucfg.tar.gz
	edos2unix `find -name '*.in' -o -name '*.am' -o -name '*.[ch]' -o -name 'config*'`

	( automake --add-missing && emake distclean ) || die "could not clean up"
}

src_compile() {
	cd src
	sed -i "/^CCFLAGS3/s:=:= ${CFLAGS} :" Makefile
	if [ `use oss` ] || [ -z "`use oss``use alsa`" ] ; then
		emake clean || die
		emake USEALSA=FALSE || die
		mv libspu* ..
	fi
	if [ `use alsa` ] ; then
		emake clean || die
		emake USEALSA=TRUE || die
		mv libspu* ..
	fi

	cd linuxcfg
	econf || die
	emake || die
	mv src/spucfg src/cfgPeopsOSS
}

src_install() {
	exeinto /usr/lib/psemu/plugins
	doexe libspu*
	exeinto /usr/lib/psemu/cfg
	doexe src/linuxcfg/src/cfgPeopsOSS
	insinto /usr/lib/psemu/cfg
	doins spuPeopsOSS.cfg
	dodoc src/*.txt *.txt
}
