# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/tcsh/tcsh-6.14-r1.ebuild,v 1.2 2005/11/02 21:17:41 grobian Exp $

MY_P="${P}.00"
DESCRIPTION="Enhanced version of the Berkeley C shell (csh)"
HOMEPAGE="http://www.tcsh.org/"
SRC_URI="ftp://ftp.astron.com/pub/tcsh/${MY_P}.tar.gz
	mirror://gentoo/${P}-conffiles.tar.bz2"
# note: starting from this version the various files scattered around
#       the place in ${FILESDIR} are now stored in a versioned tarball

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~arm ~hppa ~amd64 ~ia64 ~ppc64 ~mips"
IUSE="perl"

RDEPEND="virtual/libc
	>=sys-libs/ncurses-5.1
	perl? ( dev-lang/perl )"

S="${WORKDIR}/${MY_P}"


src_compile() {
	econf --prefix=/ || die "econf failed"
	emake || die "compile problem"
}

src_install() {
	make DESTDIR=${D} install install.man || die

	if use perl ; then
		perl tcsh.man2html || die
		dohtml tcsh.html/*.html
	fi

	[ ! -e /bin/csh ] && dosym /bin/tcsh /bin/csh
	dodoc FAQ Fixes NewThings Ported README WishList Y2K

	insinto /etc
	doins ${WORKDIR}/gentoo/csh.cshrc
	doins ${WORKDIR}/gentoo/csh.login

	insinto /etc/skel
	newins ${WORKDIR}/gentoo/tcsh.config .tcsh.config

	insinto /etc/profile.d
	doins ${WORKDIR}/gentoo/tcsh-bindkey.csh
	doins ${WORKDIR}/gentoo/tcsh-settings.csh
	doins ${WORKDIR}/gentoo/tcsh-aliases
	doins ${WORKDIR}/gentoo/tcsh-complete
	doins ${WORKDIR}/gentoo/tcsh-gentoo_legacy
}

pkg_postinst() {
	while read line; do einfo "${line}"; done <<EOF
The default behaviour of tcsh has significantly changed starting from
this ebuild.  In contrast to previous ebuilds, the amount of
customisation to the default shell's behaviour has been reduced to a
bare minimum (a customised prompt).
If you rely on the customisations provided by previous ebuilds, you will
have to copy over the relevant (now commented out) parts to your own
~/.tcshrc.  Please check all tcsh-* files in /etc/profiles.d/ and add
sourceing of /etc/profiles.d/tcsh-complete to restore previous
behaviour.
Please note that the tcsh-complete file is a large set of examples that
is not meant to be used in its exact form, as it defines an excessive --
sometimes conflicting -- amount of completion scripts.  It is highly
encouraged to copy over the desired auto completion scripts to the
personal ~/.tcshrc file.  The tcsh-complete file is not any longer
sourced by the default system scripts.
EOF
}
