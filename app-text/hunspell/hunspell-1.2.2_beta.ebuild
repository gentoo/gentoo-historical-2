# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/hunspell/hunspell-1.2.2_beta.ebuild,v 1.1 2008/02/10 19:17:26 philantrop Exp $

inherit eutils multilib autotools

MY_P=${PN}-${PV/_beta/b}

DESCRIPTION="Hunspell spell checker - an improved replacement for myspell in OOo."
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
HOMEPAGE="http://hunspell.sourceforge.net/"

SLOT="0"
LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
IUSE="ncurses readline"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND="readline? ( sys-libs/readline )
	ncurses? ( sys-libs/ncurses )
	sys-devel/gettext"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:tail +:tail -n +:' "${S}"/tests/test.sh ||\
		die "Failed to fix-up tail for POSIX compliance"

	# Upstream package creates some executables which names are too generic
	# to be placed in /usr/bin - this patch prefixes them with 'hunspell-'.
	# It modifies a Makefile.am file, hence eautoreconf.
	epatch "${FILESDIR}"/${MY_P}-renameexes.patch

	# Would still be nice to get bug 142787 fixed...
	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	# I wanted to put the include files in /usr/include/hunspell
	# but this means the openoffice build won't find them.
	econf \
		$(use_with readline readline) \
		$(use_with ncurses ui) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO license.hunspell || die "installing docs failed"
	# hunspell is derived from myspell
	dodoc AUTHORS.myspell README.myspell license.myspell || die "installing myspell docs failed"

	# Upstream install has a few problems - rather than try to figure out
	# what's broken in the build system, just fix things up manually.

	# These are included by hunspell.hxx, but aren't installed by the install
	# script.
	insinto /usr/include/hunspell/
	doins license.myspell license.hunspell config.h

	# These are in the wrong place.
	mv "${D}"/usr/include/munch.h "${D}"/usr/include/hunspell/munch.h
	mv "${D}"/usr/include/unmunch.h "${D}"/usr/include/hunspell/unmunch.h

	# Libraries include the version in their name, so make a sensible
	# default symlink.  They should probably be libhunspell.so.1.1 etc.
	dodir /usr/$(get_libdir)
	cd "${D}"/usr/$(get_libdir)
	ln -s libhunspell-1.2.so.0.0.0 libhunspell.so
}

pkg_postinst() {
	elog "To use this package you will also need a dictionary."
	elog "Hunspell uses myspell format dictionaries; find them"
	elog "in the app-dicts category as myspell-<LANG>."
}
