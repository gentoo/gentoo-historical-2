# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/anki/anki-0.9.9.3.ebuild,v 1.1 2008/12/16 23:01:16 hncaldwell Exp $

EAPI=2

inherit eutils multilib python

DESCRIPTION="A spaced-repetition memory training program (flash cards)"
HOMEPAGE="http://ichi2.net/anki/index.html"
SRC_URI="http://ichi2.net/${PN}/download/files/${P}.tgz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="furigana +graph +sound"

RDEPEND=">=dev-python/PyQt4-4.4[webkit]
	>=dev-python/sqlalchemy-0.4.1
	>=dev-python/simplejson-1.7.3
	|| ( >=dev-python/pysqlite-2.3.0 >=dev-lang/python-2.5[sqlite] )
	app-text/dvipng
	furigana? ( app-i18n/kakasi )
	graph? (
		dev-python/numpy
		>=dev-python/matplotlib-0.91.2
	)
	sound? ( dev-python/pygame )"

src_install() {
	doicon icons/${PN}.png || die

	python setup.py install --root="${D}" || die
	cd libanki
	python setup.py install --root="${D}" || die

	make_desktop_entry ${PN} ${PN} ${PN}.png "Education"
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/ankiqt
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/anki
}

pkg_postrm() {
	python_version
	python_mod_cleanup /usr/$(get_libdir)/python${PYVER}/site-packages/ankiqt
	python_mod_cleanup /usr/$(get_libdir)/python${PYVER}/site-packages/anki
}
