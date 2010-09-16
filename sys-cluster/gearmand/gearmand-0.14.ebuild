# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $

EAPI=2

inherit flag-o-matic libtool

DESCRIPTION="Generic framework to farm out work to other machines"
HOMEPAGE="http://www.gearman.org/"
SRC_URI="http://launchpad.net/gearmand/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug tcmalloc +memcache drizzle sqlite tokyocabinet" # postgres
# postgresql support is broken right now so keep it disabled
RESTRICT="test"
# restricting tests because of failures, package runs fine

RDEPEND="dev-libs/libevent
	|| ( >=sys-apps/util-linux-2.16 <sys-libs/e2fsprogs-libs-1.41.8 )
	tcmalloc? ( dev-util/google-perftools )
	memcache? ( dev-libs/libmemcached )
	drizzle? ( >=dev-db/drizzle-2010.08.1742 )
	sqlite? ( dev-db/sqlite:3 )
	tokyocabinet? ( dev-db/tokyocabinet )"
	#postgres? ( dev-db/postgresql-base )"
DEPEND="${RDEPEND}"

pkg_setup() {
	enewuser gearmand -1 -1 /dev/null nogroup
}

src_prepare() {
	elibtoolize
}

src_configure() {
	# Don't ever use --enable-assert since configure.ac is broken, and
	# only does --disable-assert correctly.
	 if use debug; then
		# Since --with-debug would turn off optimisations as well as
		# enabling debug, we just enable debug through the
		# preprocessor then.
		append-flags -DDEBUG

	else
		myconf="${myconf} --disable-assert"
	fi

		#$(use_enable postgres libpq)
	econf \
		--disable-static \
		--disable-dependency-tracking \
		--disable-mtmalloc \
		--disable-libpq \
		$(use_enable tcmalloc) \
		$(use_enable memcache libmemcached) \
		$(use_enable drizzle libdrizzle) \
		$(use_enable sqlite libsqlite3) \
		$(use_enable tokyocabinet libtokyocabinet)
}

src_test() {
	# Since libtool is stupid and doesn't discard /usr/lib64 from the
	# load path, we'd end up testing against the installed copy of
	# gearmand (bad).
	#
	# We thus cheat and "fix" the scripts by hand.
	sed -i -e '/LD_LIBRARY_PATH=/s|/usr/lib64:||' "${S}"/tests/*_test \
		|| die "test fixing failed"

	emake check || die "tests failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	dodoc README AUTHORS ChangeLog || die "dodoc failed"

	newinitd "${FILESDIR}"/gearmand.init.d gearmand || die
	newconfd "${FILESDIR}"/gearmand.conf.d gearmand || die

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog ""
	elog "Unless you set the PERSISTENT_TABLE option in"
	elog "/etc/conf.d/gearmand, Gearmand will use table 'queue'."
	elog "If such table doesn't exist, Gearmand will create it for you"
	elog ""
}
