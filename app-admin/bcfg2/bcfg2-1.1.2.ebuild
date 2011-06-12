# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/bcfg2/bcfg2-1.1.2.ebuild,v 1.1 2011/06/12 16:35:17 xmw Exp $

EAPI="3"
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
# ssl module required.
RESTRICT_PYTHON_ABIS="2.4 2.5 3.*"

inherit distutils

DESCRIPTION="Bcfg2 is a configuration management tool."
HOMEPAGE="http://bcfg2.org"

# handle the "pre" case
MY_P="${P/_/}"
SRC_URI="ftp://ftp.mcs.anl.gov/pub/bcfg/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="server"

DEPEND="app-portage/gentoolkit
	server? (
		dev-python/lxml
		app-admin/gam-server )"
RDEPEND="${DEPEND}"

PYTHON_MODNAME="Bcfg2"

distutils_src_install_post_hook() {
	if ! use server; then
		rm -f "$(distutils_get_intermediate_installation_image)${EPREFIX}/usr/sbin/bcfg2-"*
	fi
}

src_install() {
	distutils_src_install --record=PY_SERVER_LIBS --install-scripts "${EPREFIX}/usr/sbin"

	# Remove files only necessary for a server installation
	if ! use server; then
		rm -rf "${ED}usr/share/bcfg2"
		rm -rf "${ED}usr/share/man/man8"
	fi

	# Install a server init.d script
	if use server; then
		newinitd "${FILESDIR}/bcfg2-server.rc" bcfg2-server
	fi

	insinto /etc
	doins examples/bcfg2.conf || die "doins failed"
}

pkg_postinst () {
	distutils_pkg_postinst

	if use server; then
		einfo "If this is a new installation, you probably need to run:"
		einfo "    bcfg2-admin init"
	fi
}
