# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/lcdproc/lcdproc-0.4.3-r1.ebuild,v 1.4 2003/09/05 12:10:36 msterret Exp $

SRC_URI="mirror://sourceforge/lcdproc/${P}.tar.gz"
DESCRIPTION="Client/Server suite to drive all kinds of LCD (-like) devices"
HOMEPAGE="http://lcdproc.org/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"
IUSE="doc ncurses svga"
S=${WORKDIR}/${P}

DEPEND=">=sys-apps/baselayout-1.6.4
	>=sys-apps/sed-4
	doc? ( >=app-text/docbook-sgml-utils-0.6.11-r2 )
	ncurses? ( >=sys-libs/ncurses-5.3 )
	svga? ( >=media-libs/svgalib-1.4.3 )"

src_unpack() {
	unpack ${A} || die
	cd ${S}

	sed -i "889s:-O3:${CFLAGS}:" configure

	# fix a few bugs ;)
	patch -p2 < ${FILESDIR}/${P}-gentoo.diff || die \
		"Patch #1 failed."
}

src_compile() {
	local myconf

	myconf="--enable-stat-nfs --enable-drivers=mtxorb,cfontz,text,lb216,hd44780,joy,irman,lircin,"
	myconf="${myconf}bayrad,glk,stv5730,sed1330,sed1520,lcdm001,t6963"

	use ncurses && myconf="${myconf},curses"
	use svga && myconf="${myconf},svgalib"
	use samba && myconf="$myconf --enable-stat-smbfs"

	econf ${myconf} || die
	emake || die

	if [ `use doc` ]; then
		cd ${S}/docs/lcdproc-user
		docbook2html lcdproc-user.docbook
	fi
}

src_install() {
	dosbin server/LCDd
	dobin clients/lcdproc/lcdproc

	doman docs/lcdproc.1 docs/LCDd.8

	dodoc README ChangeLog COPYING INSTALL

	use doc && dohtml docs/lcdproc-user/*.html

	docinto docs
	dodoc docs/README.dg* docs/*.txt

	insinto /usr/share/doc/${PF}/clients/examples
	doins clients/examples/*.pl
	insinto /usr/share/doc/${PF}/clients/headlines
	doins clients/headlines/lcdheadlines

	insinto /etc
	doins LCDd.conf
	doins scripts/lcdproc.conf

	exeinto /etc/init.d
	doexe ${FILESDIR}/LCDd
	doexe ${FILESDIR}/lcdproc
}
