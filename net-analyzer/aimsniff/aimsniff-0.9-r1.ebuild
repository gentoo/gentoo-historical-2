# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/aimsniff/aimsniff-0.9-r1.ebuild,v 1.3 2004/06/28 21:59:52 agriffis Exp $

inherit webapp

IUSE="samba mysql apache2"

MY_P="${P}d"
WAS_VER="0.1.2b"

DESCRIPTION="Utility for monitoring and archiving AOL Instant Messenger messages across a network"
HOMEPAGE="http://www.aimsniff.com/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz
	apache2? ( mirror://sourceforge/${PN}/was-${WAS_VER}.tar.gz )"

RESTRICT="nomirror"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

S=${WORKDIR}/${MY_P}

# We need >= perl-5.8.4 for GDBM_File
DEPEND=">=dev-lang/perl-5.8.4
	dev-perl/Net-Pcap
	dev-perl/NetPacket
	dev-perl/Unicode-String
	dev-perl/FileHandle-Rollback
	dev-perl/Proc-Daemon
	dev-perl/Proc-Simple
	dev-perl/DBI
	dev-perl/Unix-Syslog
	mysql? ( dev-db/mysql dev-perl/DBD-mysql )
	samba? ( net-fs/samba )"

pkg_setup() {
	if use apache2
	then
		webapp_pkg_setup
	fi
}

src_install() {
	if use apache2
	then
		webapp_src_preinst
	fi

	newsbin aimSniff.pl aimsniff
	insinto /etc/${PN}
	doins aimsniff.config
	insinto /usr/share/doc/${PF}
	doins table.struct
	dodoc README ChangeLog

	if use apache2
	then
		cp ../was-${WAS_VER}/docs/README README.WAS
		dodoc README.WAS

		rm -rf ../was-${WAS_VER}/docs
		mv ../was-${WAS_VER}/ ${D}${MY_HTDOCSDIR}/was

		webapp_serverowned ${MY_HTDOCSDIR}/was

		# This file needs to be serverowned as the server won't be able to write to it if it were
		# webapp_configfile'ed. 
		webapp_serverowned ${MY_HTDOCSDIR}/was/.config.php

		for phpfile in `ls -a ${D}${MY_HTDOCSDIR}/was/ | grep ".php$"`; do
			webapp_runbycgibin php ${MY_HTDOCSDIR}/was/${phpfile}
		done

		webapp_src_install
	fi
}

pkg_postinst() {

	if use mysql
	then
		echo
		einfo "To create and enable the mysql database, please run: "
		einfo "ebuild /var/db/pkg/net-analyzer/${P}/${P}.ebuild config"

		if use apache2
		then
			echo "To create and enable the mysql database, please run:
			ebuild /var/db/pkg/net-analyzer/${P}/${P}.ebuild config" > apache-postinst
			webapp_postinst_txt en apache-postinst
		fi
	fi

	if use apache2
	then
		echo
		einfo "Go to http://${HOSTNAME}/was/admin.php to configure WAS."

		echo "Go to http://${HOSTNAME}/was/admin.php to configure WAS." > was-postinst
		webapp_postinst_txt en was-postinst
	fi

}

pkg_config() {
	echo
	einfo "Creating mysql database aimsniff using /usr/share/doc/${PF}/table.struct:"
	echo -n "Please enter your mysql root password: "
	read mysql_root
	/usr/bin/mysqladmin -p$mysql_root -u root create aimsniff
	/usr/bin/mysql -p$mysql_root -u root aimsniff < /usr/share/doc/${PF}/table.struct
	echo -n "Please enter your username that you want to connect to the database with: "
	read user
	echo -n "Please enter the password that you want to use for your database: "
	read password
	einfo "Granting permisions on database using 'GRANT ALL ON aimsniff.* TO $user IDENTIFIED BY '$password';'"
	echo "GRANT ALL ON aimsniff.* TO $user@localhost IDENTIFIED BY '$password';" | /usr/bin/mysql -p$mysql_root -u root aimsniff
	echo
}
