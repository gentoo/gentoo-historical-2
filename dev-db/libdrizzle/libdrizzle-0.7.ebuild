# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/libdrizzle/libdrizzle-0.7.ebuild,v 1.1 2010/01/13 09:59:57 flameeyes Exp $

EAPI=2

DESCRIPTION="a C client and protocol library for the Drizzle project"
HOMEPAGE="http://launchpad.net/libdrizzle"
SRC_URI="http://launchpad.net/libdrizzle/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug tcmalloc +sqlite static-libs"

RDEPEND="tcmalloc? ( dev-util/google-perftools )
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}"

src_configure() {
	# Don't ever use --enable-assert since configure.ac is broken, and
	# only does --disable-assert correctly.
	 if use debug; then
		# Since --with-debug would turn off optimisations as well as
		# enabling debug, we just enable debug through the
		# preprocessor then.
		append-flags -DDEBUG

	# Right now disabling asserts break the code, so never disable
	# them as it is.
	#else
	#	myconf="${myconf} --disable-assert"
	fi

	econf \
		--disable-static \
		--disable-dependency-tracking \
		--disable-mtmalloc \
		$(use_enable tcmalloc) \
		$(use_enable libsqlite3)
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS PROTOCOL README || die

	find "${D}" -name '*.la' -delete || die
}
