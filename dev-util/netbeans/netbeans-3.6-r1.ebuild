# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/netbeans/netbeans-3.6-r1.ebuild,v 1.12 2007/04/06 18:01:36 dertobi123 Exp $

IUSE="kde gnome"

MY_P=netbeans-${PV/./_}
S=${WORKDIR}/${PN}
DESCRIPTION="NetBeans IDE for Java"
SRC_URI="http://www.netbeans.org/download/release${PV//.}/promoted/FCS/${MY_P}.tar.bz2"
HOMEPAGE="http://www.netbeans.org"

SLOT="0"
LICENSE="GPL-2 Apache-1.1 sun-bcla-j2ee JPython SPL"
KEYWORDS="amd64 ia64 ppc x86"
#still need to add JPython, Sun Public and DynamicJava licenses
#sun-j2ee actually contains Sun Binary Code license
#will have to be renamed and containing it ebuilds updated at spome point..

DEPEND=">=virtual/jdk-1.3
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}

	# fix jdkhome references
	cd ${S}/bin
	# runide.sh
	sed -i -e 's:^jdkhome="":jdkhome="`java-config --jdk-home`":' \
		  runide.sh
}

src_install() {
	# remove non-x86 Linux binaries
	rm -f ${S}/bin/runide*.exe ${S}/bin/rmid_wrapper.exe
	rm -f ${S}/bin/runide_exe_defaults
	rm -f ${S}/bin/runide*.com
	rm -f ${S}/bin/runideos2.cmd
	rm -f ${S}/bin/fastjavac/fastjavac.exe
	rm -f ${S}/bin/fastjavac/fastjavac.sun
	rm -f ${S}/bin/fastjavac/fastjavac.sun.intel
	rm -f ${S}/bin/unsupported/*.bat

	# Remove MacOS X Binaries?  This doesn't necessarily make
	# sense because MacOS X could live happily beside Gentoo.
	rm -f ${S}/bin/macosx_launcher.dmg

	dodir /opt/${P}
	dodoc build_info
	dohtml CHANGES.html CREDITS.html README.html netbeans.css
	# note: docs/ are docs used internally by the IDE
	cp -Rdp ant beans bin \
		docs jakarta-tomcat-5.0.19 \
		lib modules sources \
		system update_tracking ${D}/opt/${P}
	keepdir /opt/${P}/lib/patches \
		/opt/${P}/modules \
		/opt/netbeans-3.6/jakarta-tomcat-5.0.19/server/classes \
		/opt/netbeans-3.6/jakarta-tomcat-5.0.19/classes \
		/opt/netbeans-3.6/modules/ext/locale
	dodir /usr/bin
	dosym /opt/${P}/bin/runide.sh /usr/bin/netbeans

	# If either Gnome or KDE are installed, then install the icons.
	if use gnome || use kde; then
		echo "Adding icons...."
		insinto /usr/share/pixmaps
		doins ${FILESDIR}/netbeans.png
	fi

	# If Gnome is installed, then copy in the desktop entry.
	if use gnome ; then
		einfo "Adding Gnome support...."
		insinto /usr/share/gnome/apps/Development
		doins ${FILESDIR}/netbeans.desktop
		echo "Exec=/opt/${P}/bin/runide.sh" >> ${D}/usr/share/gnome/apps/Development/netbeans.desktop
		echo >> ${D}/usr/share/gnome/apps/Development/netbeans.desktop
	fi

	# If KDE is installed, the copy in the menu entry to the
	# "Development" menu.
	# Unfortunately, the file doesn't contain any internationalized
	# text at the moment.
	if use kde ; then
		einfo "Adding KDE support...."
		DESKTOP_FILE=netbeans-KDE.desktop
		DESKTOP_DIR=/usr/share/applnk/Development
		DESKTOP=${DESKTOP_DIR}/${DESKTOP_FILE}
		insinto ${DESKTOP_DIR}
		doins ${FILESDIR}/${DESKTOP_FILE}
		echo "Name=NetBeans ${PV}" >> ${D}/${DESKTOP}
		echo "Exec=/usr/bin/netbeans" >> ${D}/${DESKTOP}
		echo "Icon=/usr/share/pixmaps/netbeans.png" >> ${D}/${DESKTOP}
		echo >> ${D}/${DESKTOP}
	fi
}
