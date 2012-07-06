# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/ldb/ldb-1.1.4.ebuild,v 1.8 2012/07/06 03:16:59 jdhore Exp $

EAPI="3"
PYTHON_DEPEND="2"

inherit python waf-utils multilib

DESCRIPTION="An LDAP-like embedded database"
HOMEPAGE="http://ldb.samba.org"
SRC_URI="http://www.samba.org/ftp/pub/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ppc ~ppc64 x86 ~x86-fbsd"
IUSE="doc"

RDEPEND="dev-libs/popt
	>=sys-libs/talloc-2.0.7[python]
	~sys-libs/tevent-0.9.14
	~sys-libs/tdb-1.2.9[python]
	net-nds/openldap
	!!<net-fs/samba-3.6.0[ldb]
	!!>=net-fs/samba-4.0.0[ldb]
	"

DEPEND="dev-libs/libxslt
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
	${RDEPEND}"

WAF_BINARY="${S}/buildtools/bin/waf-svn"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
	python_need_rebuild
}

src_configure() {
	waf-utils_src_configure --disable-rpath \
	--disable-rpath-install --bundled-libraries=NONE \
	--with-modulesdir="${EPREFIX}"/usr/$(get_libdir)/ldb/modules \
	--builtin-libraries=NONE
}

src_compile(){
	waf-utils_src_compile
	use doc && doxygen Doxyfile
}

src_test() {
	WAF_MAKE=1 \
	PATH=buildtools/bin:../../../buildtools/bin:$PATH:"${S}"/bin/shared/private/ \
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"${S}"/bin/shared/private/:"${S}"/bin/shared waf test || die
}

src_install() {
	waf-utils_src_install
	rm "${D}/$(python_get_sitedir)/"_tevent.so

	if use doc; then
		dohtml -r apidocs/html/*
		doman  apidocs/man/man3/*.3
	fi
}

pkg_postinst() {
	python_need_rebuild
	if has_version sys-auth/sssd; then
		ewarn "You have sssd installed. It is known to break after ldb upgrades,"
		ewarn "so please try to rebuild it before reporting bugs."
		ewarn "See http://bugs.gentoo.org/404281"
	fi
}
