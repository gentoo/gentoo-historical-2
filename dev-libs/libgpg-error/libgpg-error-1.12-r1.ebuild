# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgpg-error/libgpg-error-1.12-r1.ebuild,v 1.1 2014/02/06 00:22:51 radhermit Exp $

EAPI=5

inherit eutils libtool multilib-minimal

DESCRIPTION="Contains error handling functions used by GnuPG software"
HOMEPAGE="http://www.gnupg.org/related_software/libgpg-error"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="common-lisp nls static-libs"

RDEPEND="nls? ( virtual/libintl[${MULTILIB_USEDEP}] )
	abi_x86_32? (
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
		!<=app-emulation/emul-linux-x86-baselibs-20131008-r12
	)"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch_user
	elibtoolize
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		$(use_enable static-libs static)
		$(use_enable common-lisp languages)
	)

	multilib_build_binaries || myeconfargs+=(
		--disable-languages
	)

	ECONF_SOURCE=${S} \
		econf "${myeconfargs[@]}"
}

multilib_src_install() {
	default
	mv "${ED}"/usr/bin/{,"${CHOST}"-}gpg-error-config || die
	if multilib_build_binaries; then
		dosym "${CHOST}"-gpg-error-config /usr/bin/gpg-error-config
	fi
}

multilib_src_install_all() {
	einstalldocs

	# library has no dependencies, so it does not need the .la file
	prune_libtool_files --all
}
