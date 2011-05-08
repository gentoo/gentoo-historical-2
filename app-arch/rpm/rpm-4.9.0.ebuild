# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/rpm/rpm-4.9.0.ebuild,v 1.2 2011/05/08 15:13:06 sochotnicky Exp $

EAPI="3"

PYTHON_DEPEND="2"

inherit eutils autotools flag-o-matic perl-module python

DESCRIPTION="Red Hat Package Management Utils"
HOMEPAGE="http://www.rpm.org"
SRC_URI="http://rpm.org/releases/rpm-4.9.x/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="nls python doc caps lua acl"

RDEPEND=">=sys-libs/db-4.5
	>=sys-libs/zlib-1.2.3-r1
	>=app-arch/bzip2-1.0.1
	>=dev-libs/popt-1.7
	>=app-crypt/gnupg-1.2
	dev-libs/elfutils
	virtual/libintl
	>=dev-lang/perl-5.8.8
	dev-libs/nss
	python? ( >=dev-lang/python-2.3 )
	nls? ( virtual/libintl )
	lua? ( >=dev-lang/lua-5.1.0 )
	acl? ( virtual/acl )
	caps? ( >=sys-libs/libcap-2.0 )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	doc? ( app-doc/doxygen )"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.8.1-autotools.patch
	epatch "${FILESDIR}"/${PN}-4.8.1-db-path.patch

	# fix #356769
	sed -i 's:%{_var}/tmp:/var/tmp:' macros.in || die "Fixing tmppath failed"

	eautoreconf
}

src_compile() {
	default
}

src_configure() {
	econf \
		--without-selinux \
		--with-external-db \
		$(use_enable python) \
		$(use_with doc hackingdocs) \
		$(use_enable sqlite sqlite3) \
		$(use_enable nls) \
		$(use_with lua) \
		$(use_with caps cap)\
		$(use_with acl)\
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" INSTALLDIRS=vendor install || die "emake install failed"

	mv "${D}"/bin/rpm "${D}"/usr/bin
	rmdir "${D}"/bin
	# fix symlinks to /bin/rpm (#349840)
	for binary in rpmquery rpmverify;do
		ln -sf rpm "${D}"/usr/bin/$binary
	done

	use nls || rm -rf "${D}"/usr/share/man/??

	keepdir /usr/src/rpm/{SRPMS,SPECS,SOURCES,RPMS,BUILD}

	dodoc CHANGES CREDITS GROUPS README*
	use doc && dohtml -r apidocs/html/*

	# Fix perllocal.pod file collision
	fixlocalpod
}

pkg_postinst() {
	if [[ -f "${ROOT}"/var/lib/rpm/Packages ]] ; then
		einfo "RPM database found... Rebuilding database (may take a while)..."
		"${ROOT}"/usr/bin/rpmdb --rebuilddb --root="${ROOT}"
	else
		einfo "No RPM database found... Creating database..."
		"${ROOT}"/usr/bin/rpmdb --initdb --root="${ROOT}"
	fi

	use python && python_mod_optimize rpm
}

pkg_postrm() {
	use python && python_mod_cleanup rpm
}
