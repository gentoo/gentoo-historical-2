# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/libglade-java/libglade-java-2.10.1.ebuild,v 1.2 2005/06/29 15:11:18 axxo Exp $

#
# WARNING: Because java-gnome is a set of bindings to native GNOME libraries, 
# it has, like any GNOME project, a massive autoconf setup, and unlike many 
# other java libraries, it has its own [necessary] `make install` step.
# As a result, this ebuild is VERY sensitive to the internal layout of the
# upstream project. Because these issues are currently evolving upstream,
# simply version bumping this ebuild is not likely to work but FAILURES WILL
# BE VERY SUBTLE IF IT DOES NOT WORK.
# 

inherit eutils gnome.org

DESCRIPTION="Java bindings for [Lib]Glade (allows GNOME/GTK applications writen in Java to be generate their user interface based on Glade description files)"
HOMEPAGE="http://java-gnome.sourceforge.net/"
RDEPEND=">=gnome-base/libglade-2.5.1
	gnome? ( >=gnome-base/libgnomeui-2.10.0 )
	gnome? ( >=gnome-base/libgnomecanvas-2.10.0 )
	>=dev-java/libgtk-java-2.6.2
	gnome? ( >=dev-java/libgnome-java-2.10.1 )
	>=virtual/jre-1.2"


DEPEND="${RDEPEND}
		>=virtual/jdk-1.2
		app-arch/zip"

#
# Critical that this match glade's apiversion
#
SLOT="2.10"
LICENSE="LGPL-2.1"
KEYWORDS="~ppc ~x86"
IUSE="gcj gnome"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/libglade-java-2.10.0_fix-install-dir.patch

	sed -i \
		-e "s:/share/${PN}/:/share/${PN}-${SLOT}/:" \
		-e "s:/share/java/:/share/${PN}-${SLOT}/lib/:" \
		configure || die "sed configure error"

	rm -f ${S}/config.cache
}

src_compile() {
	local conf

	use gcj		|| conf="${conf} --without-gcj-compile"
	use gnome	|| conf="${conf} --without-gnome"

	cd ${S}

	#
	# Ordinarily, moving things around post `make install` would do 
	# the trick, but there are paths hard coded in .pc files and in the
	# `make install` step itself that need to be influenced.
	#

	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--with-jardir=/usr/share/${PN}-${SLOT}/lib \
			${conf} || die "./configure failed"
	make || die
}

src_install() {

	make DESTDIR=${D} install || die "install failed"

	# the upstream install scatters things around a bit. The following cleans
	# that up to make it policy compliant.

	mkdir ${D}/usr/share/${PN}-${SLOT}/src
	cd ${S}/src/java
	find . -name '*.java' | xargs zip ${D}/usr/share/${PN}-${SLOT}/src/libglade-java-${PV}.src.zip

	# with dojar misbehaving, better do to this manually for the 
	# time being. Yes, this is bad hard coding, but what in this ebuild isn't?

	echo "DESCRIPTION=${DESCRIPTION}" \
		>  ${D}/usr/share/${PN}-${SLOT}/package.env

	echo "CLASSPATH=/usr/share/${PN}-${SLOT}/lib/glade${SLOT}.jar" \
		>> ${D}/usr/share/${PN}-${SLOT}/package.env
}
