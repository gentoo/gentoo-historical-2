# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/nvi/nvi-1.81.6-r2.ebuild,v 1.6 2009/06/07 23:57:33 jer Exp $

inherit eutils flag-o-matic

DESCRIPTION="Vi clone"
HOMEPAGE="http://www.bostic.com/vi/"
SRC_URI="http://www.kotnet.org/~skimo/nvi/devel/${P}.tar.bz2"

LICENSE="Sleepycat"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc ppc64 sparc x86"
IUSE="perl tcl unicode"

DEPEND="=sys-libs/db-4*
	perl? ( dev-lang/perl )
	tcl? ( !unicode? ( >=dev-lang/tcl-8.5 ) )"
RDEPEND="${DEPEND}
	app-admin/eselect-vi"

S=${WORKDIR}/${P}/build.unix

pkg_setup() {
	if use tcl && use unicode
	then
		ewarn "nvi does not support tcl+unicode. tcl support will not be included."
		ewarn "If you need tcl support, please disable the unicode flag."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-db44.patch
	chmod +x ../dist/findconfig
}

src_compile() {
	local myconf

	use perl && myconf="${myconf} --enable-perlinterp"
	use tcl && ! use unicode && myconf="${myconf} --enable-tclinterp"
	use unicode && myconf="${myconf} --enable-widechar"

	append-flags '-D_PATH_MSGCAT="\"/usr/share/vi/catalog/\""'

	ECONF_SOURCE=../dist econf \
		--program-prefix=n \
		${myconf} \
		|| die "configure failed"
	emake OPTFLAG="${CFLAGS}" || die "make failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "install failed"
}

pkg_postinst() {
	einfo "Setting /usr/bin/vi symlink"
	eselect vi update --if-unset
}

pkg_postrm() {
	einfo "Updating /usr/bin/vi symlink"
	eselect vi update --if-unset
}
