# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/eric/eric-4.1.6.ebuild,v 1.1 2008/07/16 23:17:46 yngwin Exp $

NEED_PYTHON=2.4

inherit python eutils

MY_PN=${PN}4
MY_P=${MY_PN}-${PV}
DESCRIPTION="A full featured Python IDE that is written in PyQt4 using the QScintilla editor widget"
HOMEPAGE="http://www.die-offenbachs.de/eric/index.html"
SRC_URI="mirror://sourceforge/eric-ide/${MY_P}.tar.gz
	linguas_cs? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-cs-${PV}.tar.gz )
	linguas_de? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-de-${PV}.tar.gz )
	linguas_fr? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-fr-${PV}.tar.gz )
	linguas_ru? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-ru-${PV}.tar.gz )"

SLOT="4"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="linguas_cs linguas_de linguas_fr linguas_ru"

DEPEND="dev-python/PyQt4
	>=dev-python/qscintilla-python-2.1"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

LANGS="cs de fr ru"

python_version

pkg_setup() {
	if ! built_with_use 'dev-python/qscintilla-python' 'qt4'; then
		eerror "Please build qscintilla-python with qt4 useflag."
		die "qscintilla-python built without qt4."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/4.1.4-paths.patch
}

src_install() {
	# Change qt dir to be located in ${D}
	dodir /usr/share/qt4/
	${python} install.py \
		-z \
		-b "/usr/bin" \
		-i "${D}" \
		-d "/usr/$(get_libdir)/python${PYVER}/site-packages" \
		-c || die "python install.py failed"

	make_desktop_entry "eric4 --nosplash" \
			eric4 \
			"/usr/$(get_libdir)/python${PYVER}/site-packages/eric4/icons/default/eric.png" \
			"Development;IDE;Qt"
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/eric4{,plugins}
	elog "If you want to use eric4 with mod_python, have a look at"
	elog "\"${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/eric4/patch_modpython.py\"."
	elog
	elog "The following packages will give eric extended functionality."
	elog
	elog "dev-python/pylint"
	elog "dev-python/pysvn            (in sunrise overlay atm)"
	elog
	elog "This version has a new plugin interface with plugin-autofetch from"
	elog "the App itself. You may want to check those as well"
}

pkg_postrm() {
	python_mod_cleanup
}
