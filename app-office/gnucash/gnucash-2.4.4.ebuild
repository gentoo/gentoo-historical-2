# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/gnucash/gnucash-2.4.4.ebuild,v 1.1 2011/03/15 10:02:16 pacho Exp $

EAPI="3"
PYTHON_DEPEND="python? 2:2.4"

inherit autotools eutils gnome2 python

DOC_VER="2.2.0"

DESCRIPTION="A personal finance manager"
HOMEPAGE="http://www.gnucash.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="chipcard cxx debug +doc hbci mysql ofx postgres python quotes sqlite webkit"

# FIXME: rdepend on dev-libs/qof when upstream fix their mess (see configure.in)

RDEPEND=">=dev-libs/glib-2.13:2
	>=dev-libs/popt-1.5
	>=dev-libs/libxml2-2.5.10:2
	>=dev-scheme/guile-1.8.3:12[deprecated,regex]
	dev-scheme/guile-www
	>=dev-scheme/slib-3.1.4
	>=gnome-base/gconf-2:2
	>=gnome-base/libgnomeui-2.4
	>=gnome-base/libglade-2.4:2.0
	|| ( <gnome-base/gnome-keyring-2.29 gnome-base/libgnome-keyring )
	media-libs/libart_lgpl
	>=sys-libs/zlib-1.1.4
	>=x11-libs/gtk+-2.14:2
	x11-libs/goffice:0.8[gnome]
	x11-libs/pango
	cxx? ( dev-cpp/gtkmm:2.4 )
	ofx? ( >=dev-libs/libofx-0.9.1 )
	hbci? (
		|| (
			>=net-libs/aqbanking-5
			<net-libs/aqbanking-5[qt4]
		)
		chipcard? ( sys-libs/libchipcard )
	)
	quotes? ( dev-perl/DateManip
		>=dev-perl/Finance-Quote-1.11
		dev-perl/HTML-TableExtract )
	webkit? ( net-libs/webkit-gtk:2 )
	!webkit? ( >=gnome-extra/gtkhtml-3.16:3.14 )
	sqlite? ( dev-db/libdbi dev-db/libdbi-drivers[sqlite3] )
	postgres? ( dev-db/libdbi dev-db/libdbi-drivers[postgres] )
	mysql? ( dev-db/libdbi dev-db/libdbi-drivers[mysql] )
"
DEPEND="${RDEPEND}
	>=app-text/scrollkeeper-0.3
	dev-util/pkgconfig
	dev-util/intltool
	gnome-base/gnome-common
	sys-devel/libtool
"

PDEPEND="doc? ( >=app-doc/gnucash-docs-${DOC_VER} )"
#ELTCONF="--patch-only"

# FIXME: no the best thing to do but it'd be even better to fix autofoo
# XXX: does not break here
#MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	DOCS="doc/README.OFX doc/README.HBCI"

	if use webkit ; then
		G2CONF+=" --with-html-engine=webkit"
	else
		G2CONF+=" --with-html-engine=gtkhtml"
	fi

	if use sqlite || use mysql || use postgres ; then
		G2CONF+=" --enable-dbi"
	else
		G2CONF+=" --disable-dbi"
	fi

	G2CONF+="
		$(use_enable cxx gtkmm)
		$(use_enable debug)
		$(use_enable ofx)
		$(use_enable hbci aqbanking)
		$(use_enable python python-bindings)
		--disable-doxygen
		--enable-locale-specific-tax
		--disable-error-on-warning"

	if use python ; then
		python_set_active_version 2
	fi
}

src_configure() {
	# guile wrongly exports LDFLAGS as LIBS which breaks modules
	# Filter until a better ebuild is available, bug #202205
	local GUILE_LIBS=""
	local lib
	for lib in $(guile-config link); do
		if [ "${lib#-Wl}" = "$lib" ]; then
			GUILE_LIBS="$GUILE_LIBS $lib"
		fi
	done

	econf GUILE_LIBS="${GUILE_LIBS}" ${G2CONF}
}

src_prepare() {
	gnome2_src_prepare
	: > "${S}"/py-compile

	use python && python_convert_shebangs -r 2 .

	# Disable test broken by libtool magic ???
	epatch "${FILESDIR}/${PN}-2.4.0-disable-dynload-test.patch"

	# Disable python binding tests because of missing file
	sed 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' \
		-i src/optional/python-bindings/Makefile.{am,in} \
		|| die "python tests sed failed"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}

src_test() {
	GUILE_WARN_DEPRECATED=no \
	GNC_DOT_DIR="${T}"/.gnucash \
	emake check \
	|| die "Make check failed. See above for details."
}

src_install() {
	gnome2_src_install GNC_DOC_INSTALL_DIR=/usr/share/doc/${PF}

	rm -rf "${ED}"/usr/share/doc/${PF}/{examples/,COPYING,INSTALL,*win32-bin.txt,projects.html}
#	prepalldocs
	mv "${ED}"/usr/share/doc/${PF} "${T}"/cantuseprepalldocs || die
	dodoc "${T}"/cantuseprepalldocs/* || die
	find "${ED}" -name '*.la' -delete || die
}
