# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/linkchecker/linkchecker-8.3.ebuild,v 1.1 2013/01/15 12:32:03 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit bash-completion-r1 distutils-r1 eutils multilib

MY_P="${P/linkchecker/LinkChecker}"

DESCRIPTION="Check websites for broken links"
HOMEPAGE="http://wummel.github.com/linkchecker/ http://pypi.python.org/pypi/linkchecker/"
SRC_URI="mirror://github/downloads/wummel/${PN}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~ppc-macos ~x64-solaris"
IUSE="bash-completion bookmarks clamav doc geoip gnome login nagios syntax-check X"

RDEPEND="
	dev-python/dnspython
	bash-completion? ( dev-python/optcomplete )
	bookmarks? ( dev-python/pysqlite:2 )
	clamav? ( app-antivirus/clamav )
	geoip? ( dev-python/geoip-python )
	gnome? ( dev-python/pygtk:2 )
	login? ( dev-python/twill )
	syntax-check? (
		dev-python/cssutils
		dev-python/utidylib
		)
	X? (
		|| (
			>=dev-python/PyQt4-4.9.6-r1[X,help]
			<dev-python/PyQt4-4.9.6-r1[X,assistant] )
		dev-python/qscintilla-python
		)"
DEPEND="
	doc? ( x11-libs/qt-assistant:4 )"

RESTRICT="test"

S="${WORKDIR}/${MY_P}"

DISTUTILS_NO_PARALLEL_BUILD=true

src_prepare() {
	epatch \
		"${FILESDIR}"/8.0-missing-files.patch \
		"${FILESDIR}"/${P}-unbundle.patch \
		"${FILESDIR}"/${PN}-8.0-desktop.patch
	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile
	if use doc; then
		emake -C doc/html
	fi
}

src_install() {
	distutils-r1_src_install
	if ! use X; then
		delete_gui() {
				rm -rf \
					"${ED}"/usr/bin/linkchecker-gui* \
					"${ED}"/$(python_get_sitedir)/linkcheck/gui* || die
		}
		python_foreach_impl delete_gui
	fi
	if use doc; then
		dohtml doc/html/*
	fi
	use bash-completion && dobashcomp config/linkchecker-completion
	insinto /usr/$(get_libdir)/nagios/plugins
	use nagios && doins linkchecker-nagios
}
