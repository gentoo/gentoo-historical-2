# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/eric/eric-4.4.0.ebuild,v 1.3 2010/01/13 17:37:53 jer Exp $

EAPI="2"
NEED_PYTHON="2.6"
SUPPORT_PYTHON_ABIS="1"

inherit eutils python

MY_PN=${PN}4
MY_P=${MY_PN}-${PV}
DESCRIPTION="A full featured Python IDE using PyQt4 and QScintilla"
HOMEPAGE="http://eric-ide.python-projects.org/"
SRC_URI="mirror://sourceforge/eric-ide/${MY_P}.tar.gz"

SLOT="4"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="kde spell"

DEPEND="dev-python/PyQt4[assistant,svg,webkit,X]
	dev-python/qscintilla-python
	kde? ( kde-base/pykde4 )"
RDEPEND="${DEPEND}
	>=dev-python/chardet-2.0
	>=dev-python/pygments-1.1"
PDEPEND="spell? ( dev-python/pyenchant )"
# 2.4 and 2.5 are restricted to avoid conditional dependency on dev-python/simplejson.
RESTRICT_PYTHON_ABIS="2.4 2.5 3.*"

LANGS="cs de es fr it ru tr zh_CN"
for L in ${LANGS}; do
	SRC_URI="${SRC_URI}
		linguas_${L}? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-${L/zh_CN/zh_CN.GB2312}-${PV}.tar.gz )"
	IUSE="${IUSE} linguas_${L}"
done

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/eric-4.4-no-interactive.patch
	use kde || epatch "${FILESDIR}"/eric-4.4-no-pykde.patch

	# remove bundled copies, bug #283148
	rm -rf "${S}"/eric/ThirdParty
}

src_install() {
	installation() {
		"$(PYTHON)" install.py \
			-z \
			-b "/usr/bin" \
			-i "${D}" \
			-d "$(python_get_sitedir)" \
			-c
	}
	python_execute_function installation

	doicon eric/icons/default/eric.png
	make_desktop_entry "eric4 --nosplash" eric4 eric "Development;IDE;Qt"
}

pkg_postinst() {
	python_mod_optimize eric4{,config.py,plugins}

	elog
	elog "If you want to use eric4 with mod_python, have a look at"
	elog "\"${ROOT}usr/$(get_libdir)/python$(PYTHON -f --ABI)/site-packages/eric4/patch_modpython.py\"."
	elog
	elog "The following packages will give eric extended functionality:"
	elog "  dev-python/pylint"
	elog "  dev-python/pysvn"
	elog
	elog "This version has a plugin interface with plugin-autofetch from"
	elog "the application itself. You may want to check those as well."
	elog
}

pkg_postrm() {
	python_mod_cleanup eric4{,config.py,plugins}
}
