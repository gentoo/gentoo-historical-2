# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/eclipse-sdk-bin/eclipse-sdk-bin-2.1.ebuild,v 1.3 2003/09/06 17:30:55 karltk Exp $

DESCRIPTION="Eclipse Tools Platform, full binary" 
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download2.eclipse.org/downloads/drops/R-2.1-200303272130/eclipse-SDK-2.1-linux-gtk.zip"
IUSE=""

SLOT="0"
LICENSE="CPL-1.0"
KEYWORDS="~x86 ~ppc ~sparc"

DEPEND="${RDEPEND}
	>=virtual/jdk-1.3
	ppc? ( app-shells/tcsh )"

RDEPEND=">=virtual/jdk-1.3
	>=x11-libs/gtk+-2.2.1-r1
	=gnome-base/gnome-vfs-2*"

S=${WORKDIR}/eclipse

src_compile() {

	if [ "`use ppc`" ]
	then
		# build the SWT library
		library_dir=${S}/plugins/org.eclipse.platform.linux.gtk.source_2.1.0/src/org.eclipse.swt.gtk_2.1.0/ws/gtk/library
		mkdir ${library_dir}
		cd ${library_dir}
		unzip -q ../swtsrc.zip
		unzip -q ../swt-pisrc.zip
		sed -e "s:/bluebird/teamswt/swt-builddir/ive:\$(JAVA_HOME):" \
		    -e "s:JAVA_JNI=\$(IVE_HOME)/bin/include:JAVA_JNI=\$(IVE_HOME)/include:" \
		    -e "s:\`pkg-config --libs gthread-2.0\`:-lpthread -lgthread-2.0 -lglib-2.0:" \
		    -e "s:\`pkg-config --libs gnome-vfs-2.0\`:-lpthread -lgnomevfs-2 -lbonobo-activation -lORBit-2 -lm -llinc -lgmodule-2.0 -ldl -lgobject-2.0 -lgthread-2.0 -lglib-2.0:" \
			make_gtk.mak > make_gtk.mak_new
		cp make_gtk.mak_new make_gtk.mak

		sh build.sh || die

		# move the SWT library to the correct location and clean up
		mkdir ${S}/plugins/org.eclipse.swt.gtk_2.1.0/os/linux/ppc
		mv *.so ${S}/plugins/org.eclipse.swt.gtk_2.1.0/os/linux/ppc
		rm -rf ${S}/plugins/org.eclipse.swt.gtk_2.1.0/os/linux/x86
		cd ${S}
		rm -rf ${library_dir}

		# build the executable
		bin_dir=${S}/plugins/org.eclipse.platform.source_2.1.0/src/org.eclipse.platform_2.1.0/bin
		mkdir ${bin_dir}
		cd ${bin_dir}
		unzip -q ../launchersrc.zip
		cd library/gtk
		tcsh build.csh -arch ppc || die

		# move the executable to the correct location and clean up
		cp eclipse ${S}
		cd ${S}
		rm -rf ${bin_dir}
	fi
}

src_install() {
	dodir /opt/eclipse

	cp -dpR features install.ini  eclipse \
		icon.xpm plugins startup.jar \
		${D}/opt/eclipse/

	dohtml cpl-v10.html notice.html readme/*

	insinto /usr/share/gnome/apps/Development
	doins ${FILESDIR}/eclipse.desktop

	dodir /etc/env.d
	echo -e "LDPATH=/opt/eclipse\nPATH=/opt/eclipse\nROOTPATH=/opt/eclipse" > ${D}/etc/env.d/20eclipse
}
