# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/linkchecker/linkchecker-7.2.ebuild,v 1.2 2012/01/07 14:09:32 jlec Exp $

EAPI="3"

PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 2.5 3.*"
PYTHON_MODNAME="linkcheck"

inherit bash-completion distutils eutils

MY_P="${P/linkchecker/LinkChecker}"

DESCRIPTION="Check websites for broken links"
HOMEPAGE="http://linkchecker.sourceforge.net/ http://pypi.python.org/pypi/linkchecker"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~ppc-macos ~x64-solaris"
IUSE="bash-completion bookmarks clamav doc geoip gnome login syntax-check X"

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
		dev-python/PyQt4[X,assistant]
		dev-python/qscintilla-python
		)"
DEPEND="
	doc? ( x11-libs/qt-assistant )"

RESTRICT="test"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch \
		"${FILESDIR}"/5.2-missing-files.patch \
		"${FILESDIR}"/7.0-unbundle.patch
	distutils_src_prepare
}

src_compile() {
	distutils_src_compile
	if use doc; then
		emake -C doc/html || die
	fi
}

src_install() {
	distutils_src_install
	delete_gui() {
		if ! use X; then
			rm -rf \
				"${ED}"/usr/bin/linkchecker-gui* \
				"${ED}"/$(python_get_sitedir)/linkcheck/gui* || die
		fi
	}
	python_execute_function -q delete_gui
	if use doc; then
		dohtml doc/html/* || die
	fi
	use bash-completion && dobashcomp config/linkchecker-completion
}

pkg_postinst() {
	bash-completion_pkg_postinst
	echo ""
	distutils_pkg_postinst
}
