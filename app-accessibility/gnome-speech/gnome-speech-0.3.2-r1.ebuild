# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/gnome-speech/gnome-speech-0.3.2-r1.ebuild,v 1.4 2004/04/22 04:57:16 leonardop Exp $

inherit java-pkg gnome2

IUSE="java"

DESCRIPTION="Simple general API for producing text-to-speech output"
HOMEPAGE="http://www.gnome.org/"

SLOT="1"

KEYWORDS="x86 ~hppa ~alpha ~ia64 ~sparc ~amd64"
LICENSE="LGPL-2"


RDEPEND=">=gnome-base/libbonobo-1.97
	>=gnome-base/ORBit2-2.3.94
	java? ( virtual/jdk
		app-accessibility/java-access-bridge )"
# Support for freetts still pending, since the tarball doesn't actually
# include the driver...
# See http://bugs.gnome.org/show_bug.cgi?id=137337
#	freetts? ( app-accessibility/freetts
#		!java? ( virtual/jdk
#			app-accessibility/java-access-bridge ) )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog COPYING NEWS README"


src_compile() {
	if [ `use java` ]
	then
		if [ -z "${JDK_HOME}" ] || [ ! -d "${JDK_HOME}" ]
		then
			eerror "In order to compile java sources you have to set the"
			eerror "\$JDK_HOME environment properly."
			eerror ""
			eerror "You can achieve this by using the java-config tool:"
			eerror "  emerge java-config"
			die "Couldn't find a valid JDK home"
		fi

		local jabdir="${ROOT}/usr/share/java-access-bridge/lib"
		G2CONF="${G2CONF} --with-java-home=${JDK_HOME}"
		G2CONF="${G2CONF} --with-jab-dir=${jabdir}"
	else
		export JAVAC=no
	fi
	gnome2_src_compile
}


src_install() {
	gnome2_src_install

	if [ `use java` ]
	then
		java-pkg_dojar ${D}/usr/share/jar/*.jar
		rm -rf ${D}/usr/share/jar
	fi
}
