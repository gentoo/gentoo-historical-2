# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/rpm/rpm-5.0.0.ebuild,v 1.2 2009/08/21 13:18:32 ulm Exp $

inherit multilib distutils python

MY_P=${P/_alpha/a}
MY_P=${P/_beta/b}

DESCRIPTION="RPM Package Manager"
HOMEPAGE="http://rpm5.org/"
SRC_URI="http://rpm5.org/files/rpm/rpm-5.0/${MY_P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="berkdb bzip2 doc lua magic neon nls pcre perl python selinux sqlite"

#	dmalloc? ( dev-libs/dmalloc )
#	efence? ( dev-util/efence )
#	keyutils? ( sys-apps/keyutils )
#	xar? ( app-arch/xar )
RDEPEND="dev-libs/beecrypt
	dev-libs/popt
	berkdb? ( sys-libs/db )
	bzip2? ( app-arch/bzip2 )
	lua? ( dev-lang/lua )
	neon? ( net-misc/neon )
	pcre? ( dev-libs/libpcre )
	perl? ( dev-lang/perl )
	python? ( dev-lang/python )
	selinux? ( sys-libs/libselinux )
	sqlite? ( dev-db/sqlite )"
# comes bundled with modified zlib
#	>=sys-libs/zlib-1.2.3-r1
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -rf file xar #db
	sed -i \
		-e '/^pkgconfigdir/s:=.*:=$(libdir)/pkgconfig:' \
		scripts/Makefile.in || die
}

src_compile() {
#		$(use_with dmalloc) \
#		$(use_with efence) \
#		$(use_with keyutils) \
#		$(use_with xar) \
	# --with-libelf
	use python && python_version
	econf \
		$(use_with berkdb db) \
		$(use_with bzip2) \
		$(use_with doc apidocs) \
		$(use_with magic file) \
		$(use_with lua) \
		$(use_with neon) \
		$(use_with nls) \
		$(use_with pcre) \
		$(use_with perl) \
		$(use_with python) \
		$(use_with selinux) \
		$(use_with sqlite) \
		$(use berkdb || use sqlite || echo --with-db) \
		--with-path-lib="/usr/$(get_libdir)/rpm" \
		--with-python-lib-dir="/usr/$(get_libdir)/python${PYVER}" \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc CHANGES CREDITS NEWS README TODO
}

pkg_preinst() {
	enewgroup rpm 37
	enewuser rpm 37 /bin/sh /var/lib/rpm rpm
}

pkg_postinst() {
	chown -R rpm:rpm "${ROOT}"/usr/$(get_libdir)/rpm
	chown -R rpm:rpm "${ROOT}"/var/lib/rpm
	chown rpm:rpm "${ROOT}"/usr/bin/rpm{,2cpio,build,constant}
	if [[ ${ROOT} == "/" ]] ; then
		if [[ -f ${ROOT}/var/lib/rpm/Packages ]] ; then
			einfo "RPM database found... Rebuilding database (may take a while)..."
			"${ROOT}"/usr/bin/rpm --rebuilddb --root="${ROOT}"
		else
			einfo "No RPM database found... Creating database..."
			"${ROOT}"/usr/bin/rpm --initdb --root="${ROOT}"
		fi
	fi
	chown rpm:rpm "${ROOT}"/var/lib/rpm/*

	distutils_pkg_postinst
}
