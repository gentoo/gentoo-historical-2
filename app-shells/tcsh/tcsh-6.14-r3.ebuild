# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/tcsh/tcsh-6.14-r3.ebuild,v 1.7 2006/02/06 09:12:47 corsair Exp $

inherit eutils

MY_P="${P}.00"
DESCRIPTION="Enhanced version of the Berkeley C shell (csh)"
HOMEPAGE="http://www.tcsh.org/"
SRC_URI="ftp://ftp.astron.com/pub/tcsh/${MY_P}.tar.gz
	mirror://gentoo/${P}-conffiles.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="perl"

DEPEND=">=sys-libs/ncurses-5.1
	perl? ( dev-lang/perl )
	!app-shells/csh" # bug #119703

S=${WORKDIR}/${MY_P}


src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${MY_P}"-debian-dircolors.patch # bug #120792
	epatch "${FILESDIR}/${P}"-r2.patch
}

src_compile() {
	econf --prefix=/ || die "econf failed"
	emake || die "compile problem"
}

src_install() {
	make DESTDIR="${D}" install install.man || die

	if use perl ; then
		perl tcsh.man2html || die
		dohtml tcsh.html/*.html
	fi

	insinto /etc
	doins \
		"${WORKDIR}"/gentoo/csh.cshrc \
		"${WORKDIR}"/gentoo/csh.login

	insinto /etc/skel

	insinto /etc/profile.d
	doins \
		"${WORKDIR}"/gentoo/tcsh-bindkey.csh \
		"${WORKDIR}"/gentoo/tcsh-settings.csh

	dodoc FAQ Fixes NewThings Ported README WishList Y2K

	docinto examples
	dodoc \
		"${WORKDIR}"/gentoo/tcsh-aliases \
		"${WORKDIR}"/gentoo/tcsh-complete \
		"${WORKDIR}"/gentoo/tcsh-gentoo_legacy \
		"${WORKDIR}"/gentoo/tcsh.config

	# bug #119703: add csh -> tcsh symlink
	dosym /bin/tcsh /bin/csh
}

pkg_postinst() {

	while read line; do einfo "${line}"; done <<EOF
The default behaviour of tcsh has significantly changed starting from
version 6.14-r1.  In contrast to previous ebuilds, the amount of
customisation to the default shell's behaviour has been reduced to a
bare minimum (a customised prompt).
If you rely on the customisations provided by previous ebuilds, you will
have to copy over the relevant (now commented out) parts to your own
~/.tcshrc.  Please check all tcsh-* files in
/usr/share/tcsh-6.14-r2/example and include their behaviour in your own
configuration files.
The tcsh-complete file is not any longer sourced by the default system
scripts.
EOF
}
