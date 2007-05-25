# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-screensaver/gnome-screensaver-2.16.3.ebuild,v 1.1 2007/05/25 20:36:09 leio Exp $

inherit gnome2 eutils

DESCRIPTION="Replaces xscreensaver, integrating with the desktop."
HOMEPAGE="http://live.gnome.org/GnomeScreensaver"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc xinerama opengl pam"

RDEPEND=">=gnome-base/gconf-2.6.1
	>=x11-libs/gtk+-2.8
	>=gnome-base/gnome-vfs-2.12
	>=gnome-base/libgnomeui-2.12
	>=gnome-base/libglade-2.5.0
	>=gnome-base/gnome-menus-2.12
	>=media-libs/libexif-0.6.12
	>=dev-libs/glib-2.8
	|| (
		>=dev-libs/dbus-glib-0.71
		~sys-apps/dbus-0.62 )
	opengl?	( virtual/opengl )
	xinerama? (
		x11-libs/libXinerama
		x11-proto/xineramaproto	)
	pam? ( virtual/pam )
	!pam? ( kernel_linux? ( sys-apps/shadow ) )

	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXScrnSaver"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	doc? (
		app-text/xmlto
		~app-text/docbook-xml-dtd-4.1.2
		~app-text/docbook-xml-dtd-4.4 )

	x11-proto/xextproto
	x11-proto/randrproto
	x11-proto/scrnsaverproto
	x11-proto/xf86miscproto"

DOCS="AUTHORS ChangeLog HACKING NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF} \
		$(use_enable doc docbook-docs) \
		$(use_enable debug) \
		$(use_enable pam) \
		$(use_enable xinerama) \
		$(use_with opengl gl) \
		--enable-locking \
		--with-libexif \
		--with-dpms-ext \
		--with-gdm-config=/usr/share/gdm/defaults.conf \
		--with-xscreensaverdir=/usr/share/xscreensaver/config \
		--with-xscreensaverhackdir=/usr/lib/misc/xscreensaver"
}

src_unpack() {
	gnome2_src_unpack
	epatch "${FILESDIR}"/${PN}-2.16.2-openpam.patch
	intltoolize --force || die
}

src_install() {
	gnome2_src_install

	# Install the conversion script in the documentation
	dodoc ${S}/data/migrate-xscreensaver-config.sh
	dodoc ${S}/data/xscreensaver-config.xsl

	# Conversion information
	sed -e "s:\${PF}:${PF}:" \
		< ${FILESDIR}/xss-conversion-2.txt > ${S}/xss-conversion.txt

	dodoc ${S}/xss-conversion.txt

	# Non PAM users will need this suid to read the password hashes.
	# OpenPAM users will probably need this too when
	# http://bugzilla.gnome.org/show_bug.cgi?id=370847
	# is fixed.
	if ! use pam ; then
		fperms +s /usr/libexec/gnome-screensaver-dialog
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst

	ewarn "If you have xscreensaver installed, you probably want to disable it."
	ewarn "To prevent a duplicate Screensaver entry in the menu, you need to"
	ewarn "build xscreensaver with -gnome in the USE flags."
	ewarn "echo \"x11-misc/xscreensaver -gnome\" >> /etc/portage/package.use"
	echo
	elog "Information for converting screensavers is located in "
	elog "/usr/share/doc/${PF}/xss-conversion.txt.gz"
}
