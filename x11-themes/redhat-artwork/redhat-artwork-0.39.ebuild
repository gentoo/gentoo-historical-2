# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/redhat-artwork/redhat-artwork-0.39.ebuild,v 1.1 2002/08/31 22:40:32 blocke Exp $

DESCRIPTION="RedHat's Bluecurve theme for GTK1, GTK2, KDE3, GDM, Metacity and Nautilus"
HOMEPAGE="http://www.redhat.com"
SRC_URI="ftp://ftp.sunet.se/pub/Linux/distributions/redhat/redhat/linux/rawhide/SRPMS/SRPMS/${P}-1.src.rpm"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

# Needed to build...
DEPEND="sys-devel/autoconf
		sys-devel/automake
		app-arch/rpm2targz
		>=media-libs/gdk-pixbuf-0.2.5
        =x11-libs/gtk+-1.2*
        >=x11-libs/gtk+-2.0"
		kde? (	>=x11-libs/qt-3.0.5	
				>=kde-base/kdebase-3.0.2 )"

# Because one may only want to use the theme with kde OR gtk OR Metacity
# OR gdm, we don't want any run-time dependencies...
RDEPEND=""

S="${WORKDIR}/${P}"

# We need to change som RedHat-specific stuff to Gentoo-style...
_replace() {
	FROM=$1
	TO=$2

	for FILE in $(fgrep -r -l "${FROM}" *); do
		echo -n Changing \"${FROM}\" to \"${TO}\" in ${FILE}...
		sed "s:${FROM}:${TO}:g" < "${FILE}" > "${FILE}.$$"
		mv "${FILE}.$$" "${FILE}"
		echo Done.
	done
}

src_unpack() {
	cd ${WORKDIR}
	rpm2targz ${DISTDIR}/${A}
	tar xvzf ${P}*.src.tar.gz
	tar xvzf ${P}.tar.gz
}

src_compile() {

	# disable qt and kde support if kde use keyword is not set
	# note: qt and kde support seem to be tied together... maybe someone with
	# autoconf experience can seperate the two
	use kde || (

	rm configure
	mv configure.in configure.in.old
	sed -e	"s|dnl KDE_USE_QT||" \
		-e  "s|KDE_||g" \
		-e	"s|AC_PATH_KDE||" \
		-e	"s|art/kde/Makefile||" \
		-e	"s|art/kde/kwin/Makefile||" \
		-e	"s|art/kde/kwin/Bluecurve/Makefile||" \
			configure.in.old > configure.in

	mv art/Makefile.am art/Makefile.am.old
	sed -e 	"s|kde||" \
		-e	"s|qt||" \
			art/Makefile.am.old > art/Makefile.am

	mv art/Makefile.in art/Makefile.in.old
	sed -e  "s|kde||" \
		-e  "s|qt||" \
			art/Makefile.in.old > art/Makefile.in

	autoconf
	automake

	)

	# paths have to be fixed for kde
	use kde && (
	
	# Fix paths...
	_replace "/usr/lib/qt3"          "${QTDIR}"
	_replace '${libdir}/qt3'         "${QTDIR}"
	_replace '$(libdir)/qt3'         "${QTDIR}"
	_replace "/usr/lib/kde3"         "${KDEDIR}/lib"
	_replace '${libdir}/kde3'        "${KDEDIR}/lib"
	_replace "/usr/lib/kwin.la"      "${KDEDIR}/lib/kwin.la"

	chmod +x configure

	)
	
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	use kde && (
		mkdir -p ${D}/${KDEDIR}/share
		mv ${D}/usr/share/apps ${D}/${KDEDIR}/share/apps
		mv ${D}/usr/share/icons ${D}/${KDEDIR}/share/icons
	
	# Until someone makes a nice Gentoo-replacement for the
	# RedHat-logo in the splash, we don't install the splash
	# at all... :)
	rm -rf ${D}/${KDEDIR}/share/apps/ksplash

	)

	dodoc AUTHORS NEWS README
}
