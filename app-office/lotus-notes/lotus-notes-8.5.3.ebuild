# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/lotus-notes/lotus-notes-8.5.3.ebuild,v 1.3 2013/06/22 13:22:15 scarabeus Exp $

EAPI=5

inherit rpm

DESCRIPTION="Commercial fork of openoffice.org with extra features for company usage"
HOMEPAGE="http://www.ibm.com/software/products/us/en/ibmnotes/"
SRC_URI="lotus_notes853_linux_RI_en.tar
	http://dev.gentooexperimental.org/~scarabeus/lotus-notes-gtk-patch-20130622.tar.xz
"

LICENSE="lotus-notes"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# Technically we also need the 32bit gnome2, but meh.
# For 32bit deps not everything is stated, needs re-checking
# if someone is interested.
RDEPEND="
	amd64? (
		app-emulation/emul-linux-x86-gtklibs
		app-emulation/emul-linux-x86-motif
		app-emulation/emul-linux-x86-xlibs
	)
	x86? (
		dev-libs/dbus-glib
		dev-libs/libcroco
		gnome-base/gconf
		gnome-base/gvfs
		gnome-base/librsvg
		gnome-base/orbit
		gnome-extra/gconf-editor
		gnome-extra/libgsf
		net-dns/avahi
		x11-libs/gdk-pixbuf
		x11-themes/gtk-engines-murrine
	)
	dev-java/swt
	dev-libs/icu
"
DEPEND="${RDEPEND}"

RESTRICT="mirror fetch strip"

QA_PREBUILT="opt/ibm/lotus/notes/*"
QA_TEXTRELS="opt/ibm/lotus/notes/*"

S=${WORKDIR}

src_unpack() {
	default
	rpm_unpack ./ibm_lotus_notes-${PV}.i586.rpm
}

src_prepare() {
	sed -i \
		-e 's/..\/notes %F/..\/notes-wrapper %F/g' \
		-e 's:Office;:Office:g' \
		usr/share/applications/LotusNotes8.5.desktop || die
	sed -i \
		-e 's:Application;Office:Office;:g' \
		usr/share/applications/* || die
	sed -i \
		-e 's:`dirname "$0"`:/opt/ibm/lotus/notes/:' \
		lotus-notes-gtk-patch/notes-wrapper || die
	# force initial configuration to avoid overwritting configs in /opt/
	sed -i \
		-e '/.initial./d' \
		opt/ibm/lotus/notes/framework/rcp/rcplauncher.properties || die
}

src_compile() {
	# generate the gtk-fix for the notes to actually work with current gtk/gnome3
	cd "${S}/lotus-notes-gtk-patch" || die
	emake
}

src_install() {
	cp -r usr/ opt "${ED}" || die
	cd "${S}/lotus-notes-gtk-patch" || die
	cp notes-wrapper libnotesgtkfix.so "${ED}"/opt/ibm/lotus/notes/ || die

	dosym /opt/ibm/lotus/notes/notes-wrapper /usr/bin/lotus-notes
}

pkg_postinst() {
	elog "Keep in mind that Lotus notes are slowly merged back into"
	elog "Apache OpenOffice and LibreOffice as IBM promised to provide"
	elog "all the code to Apache Foundation."
	elog
	elog "If you will report bugs against this package provide also"
	elog "patches or the bug will be probably ignored or closed as"
	elog "CANTFIX."
}
