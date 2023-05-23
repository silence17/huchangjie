package com.hucj.hucjtest.base64;

import java.io.Serializable;

/**
 * @ProjectName: jdjch
 * @Author: huchangjie1
 * @CreateDate: 2022/10/8
 * @Version: 1.0
 * @Description:
 */
public class Personal implements Serializable {

    private static final long serialVersionUID = 7471391170055841174L;

    private String userId;
    private String name;
    private String shopId;


    public Personal(String userId, String name) {
        this.userId = userId;
        this.name = name;
    }

    @Override
    public String toString() {
        return "Personal{" +
                "userId='" + userId + '\'' +
                ", name='" + name + '\'' +
                ", shopId='" + shopId + '\'' +
                '}';
    }
}
