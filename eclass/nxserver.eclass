# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header $
#
# eclass for handling the different nxserver binaries available
# from nomachine's website

inherit rpm

ECLASS="nxserver"
INHERITED="$INHERITED $ECLASS"

HOMEPAGE="http://www.nomachine.com/"
IUSE=""
LICENSE="nomachine"
SLOT="0"
KEYWORDS="x86 -ppc-sparc -alpha -mips"
RESTRICT="mirror fetch nostrip"

MY_PV="${PV}-72"

SRC_URI="nxserver-${MY_PV}.i386.rpm"
RDEPEND="$RDEPEND
	     >=media-libs/jpeg-6b-r3
         >=sys-libs/glibc-2.3.2-r1
		 >=sys-libs/zlib-1.1.4-r1
		 >=x11-base/xfree-4.3.0-r2
		 >=net-misc/openssh-3.6.1_p2
		 >=dev-lang/perl-5.8.0-r12
		 =net-misc/nxssh-1.2.2"

DEPEND="$DEPEND
        >=sys-apps/shadow-4.0.3-r6
		>=net-misc/openssh-3.6.1_p2"

S="${WORKDIR}"

EXPORT_FUNCTIONS pkg_nofetch src_compile src_install pkg_postinst

nxserver_pkg_nofetch () {
	eerror "This package requires you to purchase NX Server from:"
	eerror
	eerror "    http://www.nomachine.com/download.php"
	eerror
	eerror "Please purchase the *$1* edition of NX Server packaged for"
	eerror "RedHat 9.0 and put the RPM file nxserver-1.2.2-72.i386.rpm"
	eerror "into $DISTDIR/"
	eerror
	eerror "This ebuild will also work with the evaluation version of"
	eerror "the *$1* edition of NX Server packaged for RedHat 9.0"

	die "Automatic download not supported"
}

nxserver_src_compile() {
	return;
}

nxserver_src_install() {
	einfo "Installing"
	find usr/NX/lib -type l -exec rm {} \;
	mv usr/NX/etc/passwd.sample usr/NX/etc/passwd
	tar -cf - * | ( cd ${D} ; tar -xf - )

	dodir /usr/NX/var
	dodir /usr/NX/var/sessions
	touch ${D}/usr/NX/var/sessions/NOT_EMPTY

	insinto /etc/env.d
	doins ${FILESDIR}/${PVR}/50nxserver

	fowners nx.root /usr/NX/etc/passwd
	fperms 0600 /usr/NX/etc/passwd
	fowners nx:root /usr/NX/nxhome
	fowners nx:root /usr/NX/var/sessions
}

nxserver_pkg_postinst() {
	einfo "Adding user 'nx' for the NX server"
	enewuser nx -1 /usr/NX/bin/nxserver /usr/NX/nxhome

	einfo "Generating SSH keys for the 'nx' user"
	if [ ! -f /usr/NX/etc/users.id_dsa ]; then
		ssh-keygen -q -t dsa -N '' -f /usr/NX/etc/users.id_dsa
	fi
	cp -f /usr/NX/nxhome/.ssh/server.id_dsa.pub.key /usr/NX/nxhome/.ssh/authorized_keys2

	if [ ! -f /usr/NX/var/broadcast.txt ]; then
	    einfo "Creating NX user registration database"
		touch /usr/NX/var/broadcast.txt
		chown nx:root /usr/NX/var/broadcast.txt

		ewarn "None of your system users are registered to use the NX Server."
		ewarn "To authorise a user, run:"
		ewarn "'/usr/NX/bin/nxserver --useradd <username>'"
	fi

	if [ ! -f /usr/NX/etc/key.txt ] ; then
		ewarn
		ewarn "You need to place your NX key.txt file into /usr/NX/etc/"
		ewarn "If you don't have one already, you can get an evaluation"
		ewarn "key, or purchase a full license, from www.nomachine.com"
		ewarn
	fi

	if [ ! -f /usr/NX/etc/node.conf ] ; then
		ewarn
		ewarn "To complete the installation, you must create a file called"
		ewarn "'/usr/NX/etc/node.conf'.  An example configuration file can"
		ewarn "be found in /usr/NX/etc"
		ewarn
	fi
}
