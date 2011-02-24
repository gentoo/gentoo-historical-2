# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/source-highlight/source-highlight-3.1.ebuild,v 1.7 2011/02/24 18:38:32 jer Exp $

EAPI="2"

inherit bash-completion versionator

DESCRIPTION="Generate highlighted source code as an (x)html document"
HOMEPAGE="http://www.gnu.org/software/src-highlite/source-highlight.html"
SRC_URI="mirror://gnu/src-highlite/${P}.tar.gz"
LICENSE="GPL-3"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ~ppc ~ppc64 s390 sh sparc x86"
SLOT="0"
IUSE="bash-completion doc"

DEPEND=">=dev-libs/boost-1.35.0-r5
	dev-util/ctags"
RDEPEND="${DEPEND}"

src_configure() {
	BOOST_PKG="$(best_version ">=dev-libs/boost-1.35.0-r5")"
	BOOST_VER="$(replace_all_version_separators _ $(get_version_component_range 1-2 "${BOOST_PKG/*boost-/}"))"

	sed -i \
		-e "s|ac_boost_path_tmp/include|ac_boost_path_tmp/include/boost-${BOOST_VER}|" \
		configure || die "sed failed"

	econf \
		--with-boost-regex="boost_regex-mt-${BOOST_VER}" \
		--without-bash-completion
}

src_install () {
	emake DESTDIR="${D}" install || die "make install failed"

	use bash-completion && dobashcompletion source-highlight-bash-completion

	# That's not how we want it
	rm -fr "${D}/usr/share"/{aclocal,doc}
	dodoc AUTHORS ChangeLog CREDITS NEWS README THANKS TODO.txt

	use doc &&  dohtml -A java doc/*.{html,css,java}
}
