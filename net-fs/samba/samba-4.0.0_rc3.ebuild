# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/samba/samba-4.0.0_rc3.ebuild,v 1.1 2012/10/16 21:29:44 vostorga Exp $

EAPI=4
PYTHON_DEPEND="2"

inherit confutils python waf-utils multilib linux-info

MY_PV="${PV/_rc/rc}"
MY_P="${PN}-${MY_PV}"

if [ "${PV}" = "4.9999" ]; then
	EGIT_REPO_URI="git://git.samba.org/samba.git"
	KEYWORDS=""
	inherit git-2
else
	SRC_URI="mirror://samba/rc/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Samba Suite Version 4"
HOMEPAGE="http://www.samba.org/"
LICENSE="GPL-3"

SLOT="0"

IUSE="acl addns ads aio avahi client cluster cups debug fulltest gnutls iprint
ldap pam quota swat syslog winbind"

RDEPEND="dev-libs/iniparser
	dev-libs/popt
	sys-libs/readline
	virtual/libiconv
	>=dev-lang/python-2.4.2
	dev-python/subunit
	sys-libs/libcap
	>=sys-libs/ldb-1.1.12
	>=sys-libs/tdb-1.2.10[python]
	>=sys-libs/talloc-2.0.7[python]
	>=sys-libs/tevent-0.9.17
	sys-libs/zlib
	>=app-crypt/heimdal-1.5[-ssl]
	ads? ( client? ( net-fs/cifs-utils[ads] ) )
	client? ( net-fs/cifs-utils )
	cluster? ( >=dev-db/ctdb-1.0.114_p1 )
	ldap? ( net-nds/openldap )
	gnutls? ( >=net-libs/gnutls-1.4.0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="mirror"

S="${WORKDIR}/${MY_P}"

CONFDIR="${FILESDIR}/$(get_version_component_range 1-2)"

WAF_BINARY="${S}/buildtools/bin/waf"

pkg_setup() {
	confutils_use_depend_all fulltest test

	python_set_active_version 2
	python_pkg_setup

	if use aio; then
		if ! linux_config_exists || ! linux_chkconfig_present AIO; then
				ewarn "You must enable AIO support in your kernel config, "
				ewarn "to be able to support asynchronous I/O. "
				ewarn "You can find it at"
				ewarn
				ewarn "General Support"
				ewarn " Enable AIO support "
				ewarn
				ewarn "and recompile your kernel..."
		fi
	fi
}

src_configure() {
	local myconf=''
	if use "debug"; then
		myconf="${myconf} --enable-developer"
	fi
	if use "cluster"; then
		myconf="${myconf} --with-ctdb-dir=/usr"
	fi
	myconf="${myconf} \
		--enable-fhs \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--with-modulesdir=/usr/$(get_libdir) \
		--disable-rpath \
		--disable-rpath-install \
		--nopyc \
		--nopyo \
		--disable-ntdb \
		--bundled-libraries=NONE \
		--builtin-libraries=NONE \
		$(use_with addns dnsupdate) \
		$(use_with acl) \
		$(use_with ads) \
		$(use_with aio aio-support) \
		$(use_enable avahi) \
		$(use_with cluster cluster-support) \
		$(use_enable cups) \
		$(use_enable gnutls) \
		$(use_enable iprint) \
		$(use_with ldap) \
		$(use_with pam) \
		$(use_with pam pam_smbpass) \
		$(use_with quota) \
		$(use_with syslog) \
		$(use_with swat) \
		$(use_with winbind)"
	CPPFLAGS="-I/usr/include/et ${CPPFLAGS}" \
		waf-utils_src_configure ${myconf}
}

src_install() {
	waf-utils_src_install

	# Make all .so files executable
	find "${D}" -type f -name "*.so" -exec chmod +x {} +

	# Move all LDB modules to their correct path
	mkdir -p "${D}"/usr/$(get_libdir)/ldb/modules/ldb
	mv "${D}"/usr/$(get_libdir)/ldb/*.so "${D}"/usr/$(get_libdir)/ldb/modules/ldb

	# Install init script
	newinitd "${CONFDIR}/samba4.initd" samba || die "newinitd failed"
}

src_test() {
	local extra_opts=""
	use fulltest || extra_opts+="--quick"
	"${WAF_BINARY}" test ${extra_opts} || die "test failed"
}

pkg_postinst() {
	# Optimize the python modules so they get properly removed
	python_mod_optimize "${PN}"

	# Warn that it's a release candidate
	ewarn "This is not a final Samba release, however the Samba Team is now making"
	ewarn "good progress towards a Samba 4.0 release, of which this is a preview."
	ewarn "Be aware the this release contains the best of all of Samba's"
	ewarn "technology parts, both a file server (that you can reasonably expect"
	ewarn "to upgrade existing Samba 3.x releases to) and the AD domain"
	ewarn "controller work previously known as 'samba4'."

	einfo "See http://wiki.samba.org/index.php/Samba4/HOWTO for more"
	einfo "information about samba 4."
}

pkg_postrm() {
	# Clean up the python modules
	python_mod_cleanup "${PN}"
}
