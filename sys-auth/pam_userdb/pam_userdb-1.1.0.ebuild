# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_userdb/pam_userdb-1.1.0.ebuild,v 1.1 2009/10/07 19:59:55 flameeyes Exp $

EAPI=1

inherit libtool multilib eutils pam toolchain-funcs flag-o-matic versionator

# BDB is internalized to get a non-threaded lib for pam_userdb.so to
# be built with.  The runtime-only dependency on BDB suggests the user
# will use the system-installed db_load to create pam_userdb databases.
BDB_VER="4.6.21"

MY_P="Linux-PAM-${PV}"

HOMEPAGE="http://www.kernel.org/pub/linux/libs/pam/"
DESCRIPTION="Linux-PAM pam_userdb (Berkeley DB) module"

SRC_URI="mirror://kernel/linux/libs/pam/pre/library/${MY_P}.tar.bz2
	http://downloads.sleepycat.com/db-${BDB_VER}.tar.gz"

LICENSE="PAM"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="nls elibc_FreeBSD"

RDEPEND="nls? ( virtual/libintl )
	!<sys-libs/pam-0.99
	>=sys-libs/pam-1.1.0"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"
RDEPEND="${RDEPEND}
	>=sys-libs/db-${BDB_VER}:$(get_version_component_range 1-2 ${BDB_VER})"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}

	elibtoolize
}

src_compile() {
	local myconf

	if use hppa || use elibc_FreeBSD; then
		myconf="${myconf} --disable-pie"
	fi

	local BDB_DIR="${WORKDIR}/db-${BDB_VER}"

	# BDB is internalized to get a non-threaded lib for pam_userdb.so to
	# be built with.  To demand-load a shared library which uses threads
	# into an application which doesn't is a Very Bad Idea!
	einfo "Building Berkley DB ${BDB_VER}..."
	cd "${BDB_DIR}/build_unix" || die

	CFLAGS="${CFLAGS} -fPIC" \
		ECONF_SOURCE="../dist" \
		econf \
		--disable-compat185 \
		--disable-cxx \
		--disable-diagnostic \
		--disable-dump185 \
		--disable-java \
		--disable-rpc \
		--disable-tcl \
		--disable-shared \
		--disable-o_direct \
		--with-pic \
		--with-uniquename="_pam" \
		--with-mutex="UNIX/fcntl" \
		--prefix="${S}/modules/pam_userdb" \
		--includedir="${S}/modules/pam_userdb" \
		--libdir="${S}/modules/pam_userdb" || die "Bad BDB ./configure"

	emake CC="$(tc-getCC)" || die "BDB build failed"
	emake install || die

	# We link against libdb_pam (*-dbpam.patch), else stupid libtool goes
	# and relinks it during install to libdb in /usr/lib
	cp -f "${S}"/modules/pam_userdb/libdb{,_pam}.a

	# Make sure out static libs are used
	append-flags -I"{S}/modules/pam_userdb"
	append-ldflags -L"${S}/modules/pam_userdb"

	cd "${S}"
	econf \
		$(use_enable nls) \
		--enable-db \
		--enable-securedir=/$(get_libdir)/security \
		--enable-isadir=/$(get_libdir)/security \
		--disable-dependency-tracking \
		--disable-prelude \
		--with-db-uniquename=_pam \
		${myconf} || die "econf failed"

	emake -C modules/pam_userdb || die "emake failed"
}

src_install() {
	emake -C modules/pam_userdb DESTDIR="${D}" install || die "make install failed"

	dodoc "${S}/modules/pam_userdb/README"

	# No, we don't really need .la files for PAM modules.
	rm -f "${D}/$(get_libdir)/security/"*.la
}

pkg_postinst() {
	elog "Since ${CATEGORY}/${PN}-1.1.0 the internal Berkeley DB version"
	elog "used is ${BDB_VER}; if you're updating from an older version"
	elog "you will have to dump and re-load the user database."
}
