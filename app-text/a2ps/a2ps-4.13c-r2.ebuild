# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/a2ps/a2ps-4.13c-r2.ebuild,v 1.2 2005/02/21 18:20:20 lanius Exp $

inherit gnuconfig eutils

S=${WORKDIR}/${PN}-${PV:0:4}
DESCRIPTION="Any to PostScript filter"
HOMEPAGE="http://www.inf.enst.fr/~demaille/a2ps/"
SRC_URI="mirror://gentoo/${P}.tar.gz
	cjk? ( http://dev.gentoo.org/~usata/distfiles/${P}-ja_nls.patch.gz ) "

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sparc x86"
IUSE="nls tetex cjk vanilla"

DEPEND=">=sys-devel/automake-1.6
	>=sys-devel/autoconf-2.57
	>=dev-util/gperf-2.7.2
	|| ( >=dev-util/yacc-1.9.1 sys-dev/bison )
	virtual/ghostscript
	>=app-text/psutils-1.17
	tetex? ( virtual/tetex )"
RDEPEND="virtual/ghostscript
	>=app-text/psutils-1.17
	tetex? ( virtual/tetex )
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${P}.tar.gz
	cd ${S}

	epatch ${FILESDIR}/a2ps-4.13-select-freebsd.patch
	epatch ${FILESDIR}/${P}-locale-gentoo.diff
	use vanilla || epatch ${FILESDIR}/a2ps-4.13-stdout.diff
	epatch ${FILESDIR}/${PV}-gcc34.patch
	use cjk && epatch ${DISTDIR}/${P}-ja_nls.patch.gz

	# improve tempfile handling
	epatch ${FILESDIR}/${P}-fixps.patch
	epatch ${FILESDIR}/${P}-psmandup.diff

	gnuconfig_update || die "gnuconfig_update failed"
	libtoolize --copy --force || die "libtoolize failed"
}

src_compile() {

	#export YACC=yacc
	econf --sysconfdir=/etc/a2ps \
		--includedir=/usr/include \
		`use_enable nls` || die "econf failed"

	export LANG=C

	# sometimes emake doesn't work
	make || die "make failed"
}

src_install() {
	dodir /usr/share/emacs/site-lisp

	einstall \
		sysconfdir=${D}/etc/a2ps \
		includedir=${D}/usr/include \
		lispdir=${D}/usr/share/emacs/site-lisp \
		|| die "einstall failed"

	dosed /etc/a2ps/a2ps.cfg

	dodoc ANNOUNCE AUTHORS ChangeLog FAQ NEWS README* THANKS TODO
}
