# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mailman/mailman-2.1.2.ebuild,v 1.5 2003/07/26 20:01:01 raker Exp $

IUSE="apache2"

DESCRIPTION="A python-based mailing list server with an extensive web interface"
SRC_URI="mirror://gnu/${PN}/${P}.tgz"
HOMEPAGE="http://www.list.org/"

SLOT="O"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc"

DEPEND=">=dev-lang/python-1.5.2
	virtual/mta
	net-www/apache"

INSTALLDIR="/usr/local/mailman"
APACHEGID="81"
MAILGID="280"

pkg_setup() {
        if ! grep -q ^mailman: /etc/group ; then
                groupadd -g 280 mailman || die "problem adding group mailman"
        fi
        if ! grep -q ^mailman: /etc/passwd ; then
                useradd -u 280 -g mailman -G cron -s /bin/bash \
					-d ${INSTALLDIR} -c "mailman" mailman
        fi
	mkdir -p ${INSTALLDIR}
	chown mailman.mailman ${INSTALLDIR}
	chmod 2775 ${INSTALLDIR}
}

src_compile() {
        cd ${S}
        ./configure \
                --prefix=${INSTALLDIR} \
                --with-mail-gid=${MAILGID} \
                --with-cgi-gid=${APACHEGID}
        make || die
}

src_install () {
	ID=${D}${INSTALLDIR}
        cd ${S}
        mkdir -p ${ID}/logs
	touch ${ID}/logs/.keep
        chown -R mailman.mailman ${ID}
        chmod 2775 ${ID}
        make prefix=${ID} var_prefix=${ID} doinstall || die
	if [ "`use apache2`" ]; then
		dodir /etc/apache2/conf/addon-modules
		insinto /etc/apache2/conf/addon-modules
		doins ${FILESDIR}/mailman.conf
	else
		dodir /etc/apache/conf/addon-modules
		insinto /etc/apache/conf/addon-modules
		doins ${FILESDIR}/mailman.conf
	fi
	dodoc ${FILESDIR}/README.gentoo
	dodoc ACK* BUGS FAQ NEWS README* TODO UPGRADING INSTALL
	dodoc contrib/README.check_perms_grsecurity contrib/mm-handler.readme
	dodoc contrib/virtusertable contrib/mailman.mc

	cp contrib/*.py contrib/majordomo2mailman.pl contrib/auto \
		contrib/mm-handler* ${D}/usr/local/mailman/bin

	# Save the old config into the new package as CONFIG_PROTECT
	# doesn't work for this package.
	if [ -f ${ROOT}/var/mailman/Mailman/mm_cfg.py ]; then
		cp ${ROOT}/var/mailman/Mailman/mm_cfg.py \
			${D}/usr/local/mailman/Mailman/mm_cfg.py
		einfo "Your old config has been saved as mm_cfg.py"
		einfo "A new config has been installed as mm_cfg.dist"
	fi
	if [ -f ${ROOT}/home/mailman/Mailman/mm_cfg.py ]; then
		cp ${ROOT}/home/mailman/Mailman/mm_cfg.py \
			${D}/usr/local/mailman/Mailman/mm_cfg.py
		einfo "Your old config has been saved as mm_cfg.py"
		einfo "A new config has been installed as mm_cfg.py.dist"
	fi

	exeinto /etc/init.d
	newexe ${FILESDIR}/mailman.rc mailman
	}

pkg_postinst() {
	cd ${INSTALLDIR}
	bin/update
	bin/check_perms -f
	einfo
	einfo "Please read /usr/share/doc/${PF}/README.gentoo.gz for additional"
	einfo "Setup information, mailman will NOT run unless you follow"
	einfo "those instructions!"
	ewarn "The home directory for mailman has been moved from /var/mailman"
	ewarn "(pre 2.1.1-r2) or /home/mailman (2.1.1-r3) to /usr/local/mailman"
	ewarn "This should hopefully solve any problems, and this is what the mailman"
	ewarn "default is. (Any existing config has been saved in the"
	ewarn "new home directory.)"
}	

pkg_config() {
	if [ "`use apache2`" ]; then
		einfo "Updating apache2 config"
		einfo "added: \"Include  conf/addon-modules/mailman.conf\""
		einfo "to ${ROOT}etc/apache2/conf/apache2.conf"
        	echo "Include  conf/addon-modules/mailman.conf" \
			>> ${ROOT}etc/apache2/conf/apache2.conf
	else
		einfo "Updating apache config"
		einfo "added: \"Include  conf/addon-modules/mailman.conf\""
		einfo "to ${ROOT}etc/apache/conf/apache.conf"
        	echo "Include  conf/addon-modules/mailman.conf" \
			>> ${ROOT}etc/apache/conf/apache.conf
	fi
}
