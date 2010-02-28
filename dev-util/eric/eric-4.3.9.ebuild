# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/eric/eric-4.3.9.ebuild,v 1.10 2010/02/28 10:00:18 arfrever Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit eutils python

MY_PN=${PN}4
MY_P=${MY_PN}-${PV}
DESCRIPTION="A full featured Python IDE that is written in PyQt4 using the QScintilla editor widget"
HOMEPAGE="http://eric-ide.python-projects.org/index.html"
SRC_URI="mirror://sourceforge/eric-ide/${MY_P}.tar.gz
	linguas_cs? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-cs-${PV}.tar.gz )
	linguas_de? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-de-${PV}.tar.gz )
	linguas_es? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-es-${PV}.tar.gz )
	linguas_fr? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-fr-${PV}.tar.gz )
	linguas_ru? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-ru-${PV}.tar.gz )
	linguas_tr? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-tr-${PV}.tar.gz )
	linguas_zh_CN? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-zh_CN.GB2312-${PV}.tar.gz )"

SLOT="4"
LICENSE="GPL-2"
KEYWORDS="amd64 hppa ppc ppc64 sparc x86"
IUSE="linguas_cs linguas_de linguas_es linguas_fr linguas_ru linguas_tr"

DEPEND="dev-python/PyQt4[svg,webkit,X]
	dev-python/qscintilla-python"
RDEPEND="${DEPEND}"
RESTRICT_PYTHON_ABIS="3.*"

S=${WORKDIR}/${MY_P}

LANGS="cs de es fr ru tr"

src_prepare() {
	epatch "${FILESDIR}/4.2.3-no-interactive.patch"
}

src_install() {
	# Change qt dir to be located in ${D}
	dodir /usr/share/qt4

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
	elog "\"${ROOT%/}$(python_get_sitedir -f)/eric4/patch_modpython.py\"."
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
