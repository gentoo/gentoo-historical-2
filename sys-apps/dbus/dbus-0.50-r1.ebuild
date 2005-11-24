# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dbus/dbus-0.50-r1.ebuild,v 1.2 2005/11/24 21:37:30 cryos Exp $

inherit eutils mono python multilib autotools debug qt3

IUSE="X gtk qt python mono doc xml2"

DESCRIPTION="A message bus system, a simple way for applications to talk to eachother"
HOMEPAGE="http://dbus.freedesktop.org/"
SRC_URI="http://dbus.freedesktop.org/releases/${P}.tar.gz"

SLOT="0"
LICENSE="|| ( GPL-2 AFL-2.1 )"
KEYWORDS="~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

RDEPEND=">=dev-libs/glib-2.6
	xml2? ( dev-libs/libxml2 )
	!xml2? ( dev-libs/expat )
	X? ( || (
		(
		x11-libs/libXt
		x11-libs/libX11
		)
	virtual/x11 ) )
	gtk? ( >=x11-libs/gtk+-2 )
	python? ( >=dev-lang/python-2.4
		>=dev-python/pyrex-0.9.3-r2 )
	qt? ( $(qt_min_version 3.3) )
	mono? ( >=dev-lang/mono-0.95 )"


DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen
		app-text/xmlto )
	doc? ( mono? ( >=dev-util/monodoc-0.16 ) )"

# needs gcj, we have no neat way of knowing if it was enabled
# Can we just depend on the java virtual and use javac?
#	java? ( sys-devel/gcc )

src_unpack() {
	unpack ${A}
	cd ${S}

	#add missing include (#78617)
	epatch ${FILESDIR}/${PN}-0.23-fd_set.patch
	# Fix dnotify support
	epatch ${FILESDIR}/${PN}-dnotify_configure-01.diff
	epatch ${FILESDIR}/${PN}-dnotify_watchdirs-01.diff
	eautoreconf
}

src_compile() {
	local myconf

	# Choose which xml library to use
	if use xml2; then
		myconf="--with-xml=libxml"
	else
		myconf="--with-xml=expat"
	fi

	# Only enable mono-docs if both mono and doc is defined
	if use mono; then
		myconf="${myconf} `use_enable doc mono-docs`"
	else
		myconf="${myconf} --disable-mono-docs"
	fi

	if use qt; then
		myconf="${myconf} --enable-qt=${QTDIR} QT_MOC=${QTDIR}/bin/moc"
	else
		myconf="${myconf} --disable-qt"
	fi

	# NOTE: I have disabled the xml docs because they are rather pointless
	econf \
		`use_with X x` \
		`use_enable gtk` \
		`use_enable python` \
		`use_enable mono` \
		`use_enable kernel_linux dnotify` \
		--enable-glib \
		--enable-verbose-mode \
		--enable-checks \
		--enable-asserts \
		--with-system-pid-file=/var/run/dbus.pid \
		--with-system-socket=/var/run/dbus/system_bus_socket \
		--with-session-socket-dir=/tmp \
		--with-dbus-user=messagebus \
		`use_enable doc doxygen-docs` \
		--disable-xml-docs \
		${myconf} \
		|| die "econf failed"

	# Don't build the mono examples, they require gtk-sharp
	touch ${S}/mono/example/{bus-listener,echo-{server,client}}.exe

	# this gets around a lib64 sandbox bug. note that this addpredict is
	# added automatically by sandbox.c for lib.
	addpredict /usr/lib64/python2.4/
	addpredict /usr/lib64/python2.3/
	addpredict /usr/lib64/python2.2/
	addpredict /usr/lib64/python2.1/

	emake
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	# Backwards compatibility for old stuff
	# we can remove this when dbi (plural of dbus)
	# <0.30 aren't in the tree
	dosym /usr/bin/dbus-daemon /usr/bin/dbus-daemon-1

	# initscript
	doinitd ${FILESDIR}/dbus

	# dbus X session script (#77504)
	# FIXME : turns out to only work for GDM, better solution needed
	exeinto /etc/X11/xinit/xinitrc.d/
	doexe ${FILESDIR}/30-dbus

	# needs to exist for the system socket
	keepdir /var/run/dbus

	keepdir /usr/lib/dbus-1.0/services
	keepdir /usr/share/dbus-1/services

	dodoc AUTHORS ChangeLog HACKING NEWS README doc/TODO
	if use doc; then
		dohtml doc/*html
	fi
}

pkg_preinst() {
	enewgroup messagebus || die "Problem adding messagebus group"
	enewuser messagebus -1 "-1" /dev/null messagebus || die "Problem adding messagebus user"
}

pkg_postinst() {
	einfo "To start the DBUS system-wide messagebus by default"
	einfo "you should add it to the default runlevel :"
	einfo "\`rc-update add dbus default\`"
}
