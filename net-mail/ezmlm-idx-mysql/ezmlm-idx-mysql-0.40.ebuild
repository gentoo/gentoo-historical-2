# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/ezmlm-idx-mysql/ezmlm-idx-mysql-0.40.ebuild,v 1.1 2002/10/16 20:56:38 drobbins Exp $

# NOTE: ezmlm-idx, ezmlm-idx-mysql and ezmlm-idx-pgsql all supported by this single ebuild
# (Please keep them in sync)

PB=ezmlm-idx
S2=${WORKDIR}/${P}
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
	mv ${S2}/* ${S}
	cd ${S}
	patch < idx.patch
	#remove cat-man pages
	cp MAN MAN.orig
	cat MAN.orig | grep -v cat > MAN
}

src_compile() {
	cd ${S}
	echo "/usr/bin" > conf-bin
	echo "/usr/share/man" > conf-man
	echo "gcc ${CFLAGS}" > conf-cc
	echo "gcc" > conf-ld
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
	install -d ${D}/usr/bin ${D}/usr/share/man
	echo "${D}/usr/bin" > conf-bin
	echo "${D}/usr/share/man" > conf-man
	make setup || die
}
