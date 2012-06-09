# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kanyremote/kanyremote-6.0.ebuild,v 1.1 2012/06/09 16:07:37 hwoarang Exp $

EAPI="2"

PYTHON_DEPEND="2"
inherit autotools python base

DESCRIPTION="KDE frontend to Anyremote"
HOMEPAGE="http://anyremote.sourceforge.net/"
SRC_URI="mirror://sourceforge/anyremote/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth"

RDEPEND=">=app-mobilephone/anyremote-6.0[bluetooth?]
	 dev-python/PyQt4[X]
	 kde-base/pykde4
	bluetooth? ( dev-python/pybluez )"
DEPEND="${RDEPEND}
	sys-devel/gettext"

pkg_setup () {
	python_set_active_version 2
}

src_prepare() {
	# using gettextize no-interactive example from dev-util/bless package
	cp $(type -p gettextize) "${T}"/
	sed -i -e 's:read dummy < /dev/tty::' "${T}/gettextize"
	"${T}"/gettextize -f --no-changelog > /dev/null
	#fix documentation directory wrt bug #316087
	sed -i "s/doc\/${PN}/doc\/${PF}/g" Makefile.am
	eautoreconf
	# workaround to bluetooth check when bluetooth use flag is disabled
	! use bluetooth && epatch "${FILESDIR}/disable_bluetooth.patch"
}
