# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/ezmlm-idx/ezmlm-idx-0.40-r1.ebuild,v 1.1 2002/11/03 03:01:33 drobbins Exp $

# NOTE: ezmlm-idx, ezmlm-idx-mysql and ezmlm-idx-pgsql all supported by this single ebuild
# (Please keep them in sync)

PB=ezmlm-idx
S2=${WORKDIR}/${PB}-${PV}
S=${WORKDIR}/ezmlm-0.53
DESCRIPTION="Simple yet powerful mailing list manager for qmail."
SRC_URI="http://gd.tuwien.ac.at/infosys/mail/qmail/ezmlm-patches/${PB}-${PV}.tar.gz http://cr.yp.to/software/ezmlm-0.53.tar.gz"
HOMEPAGE="http://www.ezmlm.org"
SLOT="0"
LICENSE="as-is"
KEYWORDS="~x86"
DEPEND="sys-apps/grep sys-apps/groff"
RDEPEND="net-mail/qmail"
PROVIDE="net-mail/ezmlm"

if [ "$PN" = "${PB}-pgsql" ]
then
	DEPEND="$DEPEND dev-db/postgresql"
	RDEPEND="$RDEPEND dev-db/postgresql"
elif [ "$PN" = "${PB}-mysql" ]
then
	DEPEND="$DEPEND dev-db/mysql"
	RDEPEND="$RDEPEND dev-db/mysql"
fi

src_unpack() {
	unpack ${A}
	cd ${S2}
	mv ${S2}/* ${S} || die
	cd ${S}
	patch < idx.patch || die
	#remove cat-man pages
	cp MAN MAN.orig
	cat MAN.orig | grep -v cat > MAN
	echo "/usr/bin" > conf-bin
	echo "/usr/share/man" > conf-man
	echo "gcc ${CFLAGS}" > conf-cc
	echo "gcc" > conf-ld
	#tweak the install to go to ${D}
	cp Makefile Makefile.orig
	sed -e "s:/install.*conf-bin\`\":/install ${D}usr/bin:" \
	-e "s:/install.*conf-man\`\":/install ${D}usr/share/man:" Makefile.orig > Makefile
}

src_compile() {
	cd ${S}
	if [ "$PN" = "${PB}-pgsql" ]
	then
		make pgsql
	elif [ "$PN" = "${PB}-mysql" ]
	then
		make mysql
	fi
	emake || die
}

src_install () {
	install -d ${D}/usr/bin ${D}/usr/share/man ${D}/etc/ezmlm
	make setup || die
	mv ${D}/usr/bin/ez*rc ${D}/etc/ezmlm
}
