# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/tcsh/tcsh-6.14-r33.ebuild,v 1.2 2007/04/10 18:38:26 grobian Exp $

inherit eutils

PATCHVER="1.4"

MY_P="${P}.00"
DESCRIPTION="Enhanced version of the Berkeley C shell (csh)"
HOMEPAGE="http://www.tcsh.org/"
SRC_URI="ftp://ftp.astron.com/pub/tcsh/${MY_P}.tar.gz
	mirror://gentoo/tcsh-config-${PATCHVER}.tar.bz2
	http://www.gentoo.org/~grobian/distfiles/tcsh-config-${PATCHVER}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="perl catalogs"

DEPEND=">=sys-libs/ncurses-5.1
	perl? ( dev-lang/perl )
	!app-shells/csh" # bug #119703

S=${WORKDIR}/${MY_P}


src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${MY_P}"-debian-dircolors.patch # bug #120792
	epatch "${FILESDIR}/${P}"-makefile.patch # bug #151951

	if use catalogs ; then
		einfo "enabling NLS catalogs support..."
		sed -i -e "s/#undef NLS_CATALOGS/#define NLS_CATALOGS/" \
			${WORKDIR}/${MY_P}/config_f.h || die
		eend $?
	fi
}

src_compile() {
	econf --prefix=/ || die "econf failed"
	emake || die "compile problem"
}

src_install() {
	emake DESTDIR="${D}" install install.man || die

	if use perl ; then
		perl tcsh.man2html tcsh.man || die
		dohtml tcsh.html/*.html
	fi

	insinto /etc
	doins \
		"${WORKDIR}"/tcsh-config/csh.cshrc \
		"${WORKDIR}"/tcsh-config/csh.login

	insinto /etc/profile.d
	doins \
		"${WORKDIR}"/tcsh-config/tcsh-bindkey.csh \
		"${WORKDIR}"/tcsh-config/tcsh-settings.csh

	dodoc FAQ Fixes NewThings Ported README WishList Y2K

	# bug #119703: add csh -> tcsh symlink
	dosym /bin/tcsh /bin/csh
}

pkg_postinst() {
	ewarn "This revision of tcsh does use a completely revamped configuration"
	ewarn "files system, which is based on the bash equivalents.  It should"
	ewarn "fix issues for KDE users, and miscelaneous issues of environment"
	ewarn "variables not set that should have, like EDITOR.  If you rely"
	ewarn "on the /etc/csh.* files heavily, you may find your setup will be"
	ewarn "broken now."
}
