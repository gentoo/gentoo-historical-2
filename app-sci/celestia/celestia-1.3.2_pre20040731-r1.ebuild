# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/celestia/celestia-1.3.2_pre20040731-r1.ebuild,v 1.1 2004/08/09 01:30:31 morfic Exp $

inherit eutils flag-o-matic gnome2

IUSE="kde gnome gtk"

SNAPSHOT="${PV/*_pre}"
S="${WORKDIR}/${P/_*}"
DESCRIPTION="Celestia is a free real-time space simulation that lets you experience our universe in three dimensions"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
SRC_URI="http://celestia.teyssier.org/download/daily/${PN}-cvs.${SNAPSHOT}.tgz"
HOMEPAGE="http://www.shatters.net/celestia"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-* ~x86"

# gnome and kde interfaces are exlcusive
DEPEND=">=media-libs/glut-3.7-r2
	virtual/glu
	media-libs/jpeg
	media-libs/libpng
	!kde? ( gtk? ( =x11-libs/gtk+-1.2*
				=x11-libs/gtkglext-1.0*
				<x11-libs/gtkglarea-1.99.0 )
			gnome? ( =gnome-base/gnome-libs-1.4* )
		)
	kde? ( >=kde-base/kdelibs-3.0.5 )"


pkg_setup() {
	# Set up X11 implementation
	X11_IMPLEM_P="$(portageq best_version "${ROOT}" virtual/x11)"
	X11_IMPLEM="${X11_IMPLEM_P%-[0-9]*}"
	X11_IMPLEM="${X11_IMPLEM##*\/}"

	einfo	"Please note:"
	einfo	"if you experience problems building celestia with nvidia drivers,"
	einfo	"you can try:"
	einfo	"opengl-update ${X11_IMPLEM}"
	einfo	"emerge celestia"
	einfo	"opengl-update nvidia"
}

src_unpack() {
	unpack ${A}
	cd ${S}
	# the patch didn't apply correcty. Had no time to check if the patch 
	# is no longer necessary
#	epatch ${FILESDIR}/${PN}-1.3.1-gtkmain.patch
	# adding gcc-3.4 support as posted in
	# (http://bugs.gentoo.org/show_bug.cgi?id=53479#c2)
	epatch ${FILESDIR}/resmanager.h.patch || die

}

src_compile() {
	local myconf

	filter-flags "-funroll-loops -frerun-loop-opt"
	addwrite ${QTDIR}/etc/settings
	# currently celestia's "gtk support" requires gnome
	if  use kde; then
	    myconf="$myconf --with-kde"
		set-kdedir 3
		set-qtdir 3
		export kde_widgetdir="$KDEDIR/lib/kde3/plugins/designer"
	elif use gnome; then
		myconf="$myconf --with-gnome"
	elif use gtk; then
		myconf="$myconf --with-gtk"
	else
		die "!!! You need to choose either USE=kde or USE=i\"-kde gnomei\""
	fi

	./configure --prefix=/usr ${myconf} || die

	emake all || die
}

src_install() {
	if use gnome; then
		gnome2_src_install
	else
		make install prefix=${D}/usr
	fi
	# removed NEWS as it is not included in this snapshot
	dodoc AUTHORS COPYING README TODO controls.txt
	dohtml manual/*.html manual/*.css
}
